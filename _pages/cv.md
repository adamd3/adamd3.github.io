---
layout: archive
title: 'CV'
permalink: /cv/
author_profile: true
redirect_from:
  - /resume
---

{% include base_path %}

# Work experience and Education

- **2020-Present:** Research Associate in Data Science, Department of Medicine, University of Cambridge, UK

  - Analysis, integration, and interpretation of high-dimensional genomics data sets and clinical data sets
  - Driving research objectives; developing data analysis pipelines and packages; writing and editing manuscripts for publication
  - Close collaboration with clinicians, statisticians, molecular biologists, and industry partners

- **2016 - 2019:** Bioinformatician, Department of Pathology, University of Cambridge, UK

  - Analysis and interpretation of high-throughput biological sequence data sets
  - Training and supervising PhD students, undergraduates, and summer students

- **2012-2016:** PhD in Computational Infection Biology, University College Dublin, Ireland
  - Wellcome Trust Computational Infection Biology PhD programme
  - Formal training in statistical methods for genome-scale research

# Skills and expertise

- Containerisation systems (Docker, Singularity) and package/environment management systems (Conda, venv).
- Integrative analysis of genome-scale omics data sets
  - Genomics, transcriptomics, proteomics, epigenomics, CRISPR.
- CI/CD and version control
- Bioinformatics pipeline development using modern workflow management systems (Nextflow, Snakemake, bash).
- Database handling and migration (PostgreSQL, SQLite, MySQL).
- API deployment and web app development: back-end (Flask, FastAPI, gunicorn, uvicorn) and front-end (React, Shiny).
- Deployment to high-performance computing (HPC) clusters and on cloud-based platforms (AWS).

# Publications

  <ul>{% for post in site.publications reversed %}
    {% include archive-single-cv.html %}
  {% endfor %}</ul>
  
Presentations
======
- **2022** Genome Informatics conference, Sanger Institute, UK
- **2022** EMBO BactNet conference, San Feliu de Guixols, Spain
- **2019** Microbiology Society - Annual Conference, Belfast, UK
- **2016** EMBO Bioinformatics and Genome Analyses workshop, Turkey
- **2015** Microbiology Society, Irish Division Meeting, Galway, Ireland
- **2014** International Symposium on the Biology of the Actinomycetes, Izmir, Turkey
