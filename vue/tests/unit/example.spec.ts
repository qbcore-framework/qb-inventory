import { shallowMount } from "@vue/test-utils";
import App from "@/App.vue";

describe("App", () => {
  it("renders main", () => {
    const wrapper = shallowMount(App);
    expect(wrapper.find("main").exists()).toBe(true);
  });
});
