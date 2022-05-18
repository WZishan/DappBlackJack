<template>
  <div id="match" ref="mainHeight">
    <div class="dealer_box user_box">
        <div class="card_box">
            10
        </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "match",
  data() {
    return {};
  },
  methods: {},
  beforeMount() {},
};
</script>

<style scoped="scoped" lang="scss">
#match {
    .user_box{
        height: 30vh;
        width: 100vw;
        padding: 0 5vw;
        background: red;
    }
}
</style>
