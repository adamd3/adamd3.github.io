import type { Site, Metadata, Socials } from "@types";

export const SITE: Site = {
  NAME: "Adam Dinan",
  EMAIL: "ad866@cam.ac.uk",
  NUM_POSTS_ON_HOMEPAGE: 3,
  NUM_WORKS_ON_HOMEPAGE: 2,
  NUM_PROJECTS_ON_HOMEPAGE: 3,
};

export const HOME: Metadata = {
  TITLE: "Adam Dinan",
  DESCRIPTION: "Software engineer and data scientist.",
};

export const BLOG: Metadata = {
  TITLE: "Blog",
  DESCRIPTION: "A collection of articles I've written about topics that interest me.",
};

export const EXPERIENCE: Metadata = {
  TITLE: "Experience",
  DESCRIPTION: "Where I have worked and what I have done.",
};

export const PRESENTATIONS: Metadata = {
  TITLE: "Presentations",
  DESCRIPTION: "A list of presentations I have given.",
};

export const SOCIALS: Socials = [
  { 
    NAME: "github",
    HREF: "https://github.com/adamd3"
  },
  { 
    NAME: "linkedin",
    HREF: "https://www.linkedin.com/in/adam-dinan-33726a24a/",
  }
];
