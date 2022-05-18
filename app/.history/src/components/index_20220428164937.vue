<template>
  <div id="index" ref="mainHeight">
    <div class="header">
		Welcome To BlackJack
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
    font-size: 10vw;
	}
}
</style>
