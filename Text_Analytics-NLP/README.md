# Text Analytics
This group of projects uses mainly `Python`, `Tensorflow\Keras` and other NLP toolkits to explore both traditional and modern techniques used in Natural Language Processing (NLP) applications.

## 🧮 Statistical Language Models
This project focuses on developing statistical language models for **auto-completing** sentences and **spellchecking**, using n-grams and Lidstone smoothing. It includes data preprocessing, vocabulary construction, and probability estimation. Key aspects are the use of bigram and trigram models, their evaluation via cross-entropy and perplexity, and their application in auto-completion and context-aware spelling correction. The results highlight the trade-offs between bigram and trigram models in terms of coherence, fluency, and error rates, with bigrams performing better in some aspects due to n-gram sparsity in trigrams.

- **N-gram models**: [Code](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/1_statistical_language_models/ta_A1_ngram_models.ipynb), [Report](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/1_statistical_language_models/ta_A1_report.pdf)

## 🚀 Neural Networks and Deep Learning
A series of mini-projects aim to tackle the problems of **sentiment analysis** and **part-of-speech tagging** initially using Multi-Layer Perceptron (MLP) classifiers, and incrementally improving the results by replacing them with CNN, RNN and Transformer classifiers. Employing the [IMDB Dataset](https://ai.stanford.edu/~amaas/data/sentiment/) for sentiment analysis and the [English-GUM](https://github.com/UniversalDependencies/UD_English-GUM) dataset from Universal Dependencies treebanks for part-of-speech tagging, the results demonstrate significant improvements over baseline models.

- **Multi-Layer Perceptrons**: [Sentiment-Analysis](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/2_mlp/ta_A2_sentiment.ipynb), [POS-Tagging](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/2_mlp/ta_A2_POS.ipynb), [Report](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/2_mlp/ta_A2_report.pdf)
- **Recurrent Neural Networks**: [Sentiment-Analysis](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/3_rnn/ta_A3_sentiment.ipynb) [POS-Tagging](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/3_rnn/ta_A3_pos.ipynb), [Report](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/3_rnn/ta_A3_report.pdf)
- **Convolutional Neural Networks**: [Sentiment-Analysis](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/4_cnn/ta_A4_sentiment.ipynb) [POS-Tagging](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/4_cnn/ta_A4_pos.ipynb), [Report](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/4_cnn/ta_A4_report.pdf)
- **Transformers**: [Sentiment-Analysis](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/5_transformers/ta_A5_sentiment.ipynb) [POS-Tagging](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/5_transformers/ta_A5_pos.ipynb), [Report](https://github.com/FoivosM/Text_Analytics-NLP/blob/master/5_transformers/ta_A5_report.pdf)

### Contributions
These mini-projects were a group effort between *[Maria Grammatikopoulou](tbd)*, *[Melina Moniaki](tbd)* and myself.
