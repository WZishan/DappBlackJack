<template>
  <div id="index" ref="mainHeight">
    <div class="header">
      Game Over
    </div>
    <div class="btn_content">
      <div>
        <el-button class="click_btn" @click="start_click">NEXT GAME</el-button>
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
    height: 30vh;
    width: 100vw;
    line-height: 30vh;
    text-align: center;
    font-size: 5vw;
  }
  .btn_content {
    height: 70vh;
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
