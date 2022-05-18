<template>
  <div id="app">
    <router-view name="index" />
  </div>
</template>

<script>
export default {
  name: 'App',
}
</script>

<style lang="scss">
#app {
  font-family: PingFangSC-Medium, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
}
*{
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.el-cascader-menu__list {
  height: 50vh !important;
}
</style>
