<template>
  <div id="index" ref="mainHeight">
    <div class="header">
      Congratulations!
      <br>
      Total amount:
    </div>
    <div class="btn_content">
      <div>
        <el-button class="click_btn">NEXT GAME</el-button>
      </div>
      <div>
        <el-button class="click_btn">EXIT</el-button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "index",
  data() {
    return {};
  },
  methods: {},
  beforeMount() {},
};
</script>

<style scoped="scoped" lang="scss">
#index {
  .header {
    height: 50vh;
    width: 100vw;
    line-height: 25vh;
    font-size: 5vw;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
  }
  .btn_content {
    height: 50vh;
    width: 100vw;
    display: flex;
    align-content: center;
    justify-content: center;
    flex-wrap: wrap;
    div {
      width: 100%;
      height: 20vh;
      .click_btn {
        width: 23vw;
        height: 5vw;
        font-size: 2vw;
      }
    }
  }
}
</style>
