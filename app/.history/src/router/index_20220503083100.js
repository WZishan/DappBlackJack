import Vue from 'vue'
import VueRouter from 'vue-router'
import index from '../components/index.vue'

Vue.use(VueRouter)

const routes = [{
    path: '/',
    components: {
        index
    }
}, {
    path: '/match',
    components: {
        index: () =>
            import ('../components/match.vue')
    }
}, {
    path: '/win',
    components: {
        index: () =>
            import ('../components/win.vue')
    }
}, {
    path: '/game_over',
    components: {
        index: () =>
            import ('../components/game_over.vue')
    }
}, ]

const router = new VueRouter({
    routes
})

export default router