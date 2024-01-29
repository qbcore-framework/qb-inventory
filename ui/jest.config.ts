import type { Config as JestConfig } from "@jest/types";
import { compilerOptions } from "./tsconfig.json";
import { pathsToModuleNameMapper } from "ts-jest";

const jestConfig: JestConfig.InitialOptions = {
  preset: "@vue/cli-plugin-unit-jest/presets/typescript-and-babel",
  moduleDirectories: ["node_modules", "<rootDir>"],
  moduleNameMapper: pathsToModuleNameMapper(compilerOptions.paths),
};

export default jestConfig;
