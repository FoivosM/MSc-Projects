package gr.aueb.panagiotisl.mapreduce.wordcount;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Driver {
    public static void main(String[] args) throws Exception {

        System.setProperty("hadoop.home.dir", "/");

        // Instantiate a configuration
        Configuration configuration = new Configuration();

        // Instantiate a job
        Job job = Job.getInstance(configuration, "Danceability Analysis");

        // Set job parameters
        job.setJarByClass(DanceabilityAnalysis.class); // Point to the map-reduce class in the other file that declares the functions
        job.setMapperClass(DanceabilityAnalysis.DanceabilityMapper.class); // Specify which is the mapper
        job.setReducerClass(DanceabilityAnalysis.DanceabilityReducer.class); // Specify which is the reducer

        // Set the output key and value classes to match the Reducer's output types
        job.setOutputKeyClass(Text.class); // Set the data type for the key
        job.setOutputValueClass(Text.class); // Set the data type for the value

        // set io paths
        FileInputFormat.addInputPath(job, new Path("/user/hdfs/input/universal_top_spotify_songs.csv")); // to arxeio input
        FileOutputFormat.setOutputPath(job, new Path("/user/hdfs/output/")); // Where to store the results

        // Wait and Exit after job completion
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
