git clone https://github.com/markhorn-dev/astro-nano.git temp-nano
mv temp-nano/* .
mv temp-nano/.* .
rm -rf temp-nano

# modify astro.config.mjs to add site domain

npm install	


# npx astro add tailwind


# mkdir -p src/lib

# rm -rf src/layouts/* src/components/* src/styles/*

# cp -r temp-nano/src/layouts/* src/layouts/
# cp -r temp-nano/src/components/* src/components/
# cp -r temp-nano/src/styles/* src/styles/
# cp -r temp-nano/src/content/* src/content/   # For the content structure
# cp -r temp-nano/src/lib/* src/lib/  
# cp -r temp-nano/src/*ts src/  

# # Copy config files
# cp temp-nano/astro.config.mjs .   # merge this with the current astro.config.mjs
# cp temp-nano/tailwind.config.mjs .  
# cp temp-nano/tsconfig.json .

# # Clean up
# rm -rf temp-nano

# # Regular dependencies
# npm install @fontsource/inter @fontsource/lora clsx tailwind-merge sharp

# # Dev dependencies
# npm install -D @tailwindcss/typography @astrojs/check typescript @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint eslint-plugin-astro eslint-plugin-jsx-a11y

