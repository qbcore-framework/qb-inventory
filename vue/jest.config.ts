import type { Config as JestConfig } from "@jest/types";

const jestConfig: JestConfig.InitialOptions = {
  preset: "@vue/cli-plugin-unit-jest/presets/typescript-and-babel",
};

export default jestConfig;
