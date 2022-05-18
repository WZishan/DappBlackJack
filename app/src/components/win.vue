<template>
  <div id="win_content">
    <div class="header">
      Congratulations!
      <br>
     
    </div>
    <div class="btn_content">
      <div>
        <el-button class="click_btn" @click="start_click">BACK</el-button>
      </div>

    </div>
  </div>
</template>

<script>
export default {
  name: "win_content",
  data() {
    return {};
  },
  methods: {
    start_click() {
      this.$router
        .push({
          path: "/",
        })
        .catch((err) => {
          err;
        });
    },
  },
  beforeMount() {},
};
</script>

<style scoped="scoped" lang="scss">
#win_content {
  .header {
    height: 50vh;
    width: 100vw;
    line-height: 20vh;
    font-size: 5vw;
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    align-content: center;
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
