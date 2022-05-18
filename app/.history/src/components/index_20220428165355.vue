<template>
  <div id="index" ref="mainHeight">
    <div class="header">
		Welcome To BlackJack
    </div>
    <div class="btn_content">
      <el-button class="click_btn">默认按钮</el-button></br>
      <el-button class="click_btn">默认按钮</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: "index",
  data() {
  	return{

  	}  },
  methods: {
  },
  beforeMount() {
  },
};
</script>

<style scoped="scoped" lang="scss">
#index {
	.header{
		height:30vh;
		width:100vw;
		line-height:30vh;
    text-align: center;
    font-size: 5vw;
	}
  .btn_content{
		height:70vh;
		width:100vw;
    display: flex;
    align-content: space-around;
    justify-content: center;
    flex-wrap: wrap;
    .click_btn{
      width: 20vw;
      height: 5vw;
      font-size: 2vw;
    }
  }
}
</style>
