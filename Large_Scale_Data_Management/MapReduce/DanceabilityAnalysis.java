package gr.aueb.panagiotisl.mapreduce.wordcount;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.naming.Context;

public class DanceabilityAnalysis {

    public static class DanceabilityMapper extends Mapper<LongWritable, Text, Text, Text> {
        private Text countryMonth = new Text(); // variable to store the country and parsed snapshot date --> key
        private Text songData = new Text(); // variable to store the details about this song --> value

        @Override
        public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
            // Split the CSV line considering commas inside quotes
            String[] tokens = value.toString().split(",(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)", -1);

            try {
                // For each song: Keep the country, date, name of the song, its danceability
                String country = tokens[6].replaceAll("\"", ""); // Remove the quotes, ex: "GR" -> GR
                String date = tokens[7].replaceAll("\"", "");
                String songName = tokens[1].replaceAll("\"", "");
                String danceability = tokens[13].replaceAll("\"", "");

                // Format the date from "yyyy-MM-dd" to "YYYY-MM" for aggregation purposes
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date snapshotDate = sdf.parse(date);
                sdf.applyPattern("yyyy-MM");
                String monthYear = sdf.format(snapshotDate);

                // Set the key and value pair
                countryMonth.set(country + ":" + monthYear); // This is the key, ex: "MX:2024-01"
                // Set "~" as separator because there are song titles containing ":"
                songData.set(songName + "~" + danceability); // This is the value, ex: "Takata~ 0.92"

                context.write(countryMonth, songData); //The key-value pair to be passed to reduce function
            } catch (Exception e) {
                // Just in case
            }
        }
    }

    public static class DanceabilityReducer extends Reducer<Text, Text, Text, Text> {
        @Override
        public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
            // Assume the key right now is "MX:2024-01"
            double maxDanceability = 0; // Store the max danceability for this key
            String mostDanceableSong = ""; // Store the name of the most danceable song
            double totalDanceability = 0; // Keep the sum of the danceabilities for this key
            int count = 0; // Keep the total number of songs, for the calculation of AVERAGE
    
            for (Text val : values) { // For each value, ex: "Takata~ 0.92"
                String[] songData = val.toString().split("~"); // Split value into: [Takata, 0.92]
                try {
                    double danceability = Double.parseDouble(songData[1]); // keep the 0.92 as the danceability
                    totalDanceability += danceability; // Add it to the total danceability for this month
                    count++; // The increase the denominator
    
                    // If this song is more danceable than the most danceable, make this the most danceable song
                    if (danceability > maxDanceability) {
                        maxDanceability = danceability;
                        mostDanceableSong = songData[0];
                    }
                } catch (NumberFormatException e) {
                    // Just in case
                }
            }
    
            // Calculate AVERAGE danceability for the month
            if (count > 0) { // To catch zero divisions while calculating the average
                double avgDanceability = totalDanceability / count;
                // Round the average danceability to 3 decimal places
                avgDanceability = Math.round(avgDanceability * 1000.0) / 1000.0;
    
                // Prepare the output in CSV format
                String result = String.format("\"%s\",\"%s\",\"%s\",\"%.3f\",\"%.3f\"", 
                // Split the key MX:2024-01 to [MS, 2024-01]
                key.toString().split(":")[0], // Country
                key.toString().split(":")[1], // Date
                mostDanceableSong, // Most danceable song
                maxDanceability, // Max danceability, rounded in the string format
                avgDanceability); // Average danceability, rounded in the string format
                
                // KEY: Instead of passing the key in the context, i pass it in the value to have more freedom for the formating
                context.write(null, new Text(result)); // Write the result with null as key
            }
        }
    }

}

