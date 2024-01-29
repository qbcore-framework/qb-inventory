const { defineConfig } = require("@vue/cli-service");
module.exports = defineConfig({
  transpileDependencies: true,
  configureWebpack: {
    experiments: {
      topLevelAwait: true,
    },
  },
  chainWebpack: (config) => {
    // Setup NuiMocker in development mode
    if (process.env.NODE_ENV === "development") {
      config.entry("app").add("./src/mock/NuiMocker.ts");
    }
  },
});
