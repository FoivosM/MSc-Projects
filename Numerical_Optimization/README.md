# Numerical Optimization and Large Scale Lineal Algebra
These are my university assignments in the titular course.
## 📈 Project 1 - House Price Prediction
This is an introductory project to Linear Regression. It involves:
- Simple Linear Regression.
- Transformations to account for Heteroscedasticity.
- Cross-validation.

## 💡 Project 2 - Constrained Least Squares and Optimization
The goal of this project is to optimize the lighting in a specific area using a set of lamps. The area is divided into small regions, called pixels, and each region's lighting level is determined by the power of the lamps illuminating it. It includes:
- Constrained Least Squares, to optimize the light intensity of the lamps, in the given space.
- Local Best variant of [**Particle Swarm Optimization**](https://en.wikipedia.org/wiki/Particle_swarm_optimization), to optimize the lamp positions.

## 🔢 Project 3 - Image Classification with SVD
This exercise involves constructing an algorithm for the classification of handwritten digits by computing the SVD of each class matrix, using the first few singular vectors as basis, and classifying test digits based on their representation in terms of these bases.
- Singular Vector Decomposition.
- Classification.

## 🕸 Project 4 - PageRank
This is an attempt to replicate Google's PageRank algorithm (following [this](https://www.stat.uchicago.edu/~lekheng/meetings/mathofranking/ref/langville.pdf) paper), which aims to order a set of available web pages by their *status* in relation to every other available page. Additionally, the effect of the malicious practice of *Link Farms* is examined, which tries to surreptitiously boost the status of a web page.
- PageRank computation using the power method.
- PageRank computation using system of linear equations.
- How to create a Link Farm 🤫.

## 👨‍🔬 Project 5 - NLP
This project aims to hierarchically classify academic papers based on their abstracts into respective categories. It utilizes Latent Semantic Analysis (LSA) and Correspondence Analysis for abstract representations. Additionally, the project employs cosine similarity to identify similarities between papers, enhancing the classification process and enabling efficient literature exploration.

- Latent Semantic Analysis (LSA).
- Correspondence Analysis (CA).
- Hierarchical Clustering.
- Cosine Similarity.