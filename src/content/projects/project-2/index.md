---
title: 'BactGraph'
description: 'A graph neural network for studying bacterial gene regulation'
date: 'Jan 23 2025'
repoURL: 'https://github.com/Floto-Lab/BactGraph'
---

![Astro Nano](/astro-nano.png)

BactGraph is a Graph Attention Network for studying gene regulation in bacteria.

It uses three key inputs:

- An adjacency matrix for a network of known gene-gene (or protein-protein) interactions.
- An matrix of normalised expression values for genes in the adjacency matrix.
- Protein embeddings (e.g. ESM-2) for the set of genes/proteins in the network.
