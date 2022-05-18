module.exports = {
    // 部署应用时的基本 URL
    //baseUrl: process.env.NODE_ENV === 'production' ? '192.168.60.110:8080' : '192.168.60.110:8080',
    publicPath: './', //部署应用时的根路径(默认'/'),也可用相对路径(存在使用限制)
    // build时构建文件的目录 构建时传入 --no-clean 可关闭该行为
    outputDir: 'gamble',
    // build时放置生成的静态资源 (js、css、img、fonts) 的 (相对于 outputDir 的) 目录
    assetsDir: 'gamble',
    // 指定生成的 index.html 的输出路径 (相对于 outputDir)。也可以是一个绝对路径。
    indexPath: 'index.html',
    // 默认在生成的静态资源文件名中包含hash以控制缓存
    filenameHashing: true,
    // 构建多页面应用，页面的配置
    pages: {
        index: {
            // page 的入口
            entry: 'src/main.js',
            // 模板来源
            template: 'public/index.html',
            // 在 dist/index.html 的输出
            filename: 'index.html',
            // 当使用 title 选项时，template 中的 title 标签需要是 <title><%= htmlWebpackPlugin.options.title %></title>
            title: '小游戏',
            // 在这个页面中包含的块，默认情况下会包含
            // 提取出来的通用 chunk 和 vendor chunk。
            chunks: ['chunk-vendors', 'chunk-common', 'index']
        },
        // 当使用只有入口的字符串格式时，模板会被推导为 `public/subpage.html`，并且如果找不到的话，就回退到 `public/index.html`。
        // 输出文件名会被推导为 `subpage.html`。
        //subpage: 'src/main.js'
    },
    // 是否在开发环境下通过 eslint-loader 在每次保存时 lint 代码 (在生产构建时禁用 eslint-loader)
    lintOnSave: false,
    // 是否使用包含运行时编译器的 Vue 构建版本
    runtimeCompiler: false,
    // Babel 显式转译列表
    transpileDependencies: [],
    // 如果你不需要生产环境的 source map，可以将其设置为 false 以加速生产环境构建
    productionSourceMap: true,
    // 设置生成的 HTML 中 <link rel="stylesheet"> 和 <script> 标签的 crossorigin 属性（注：仅影响构建时注入的标签）

    crossorigin: '',
    // 在生成的 HTML 中的 <link rel="stylesheet"> 和 <script> 标签上启用 Subresource Integrity (SRI)
    integrity: false,
    // 如果这个值是一个对象，则会通过 webpack-merge 合并到最终的配置中
    // 如果你需要基于环境有条件地配置行为，或者想要直接修改配置，那就换成一个函数 (该函数会在环境变量被设置之后懒执行)。该方法的第一个参数会收到已经解析好的配置。在函数内，你可以直接修改配置，或者返回一个将会被合并的对象
    configureWebpack: {
        resolve: {
            alias: {
                vue$: "vue/dist/vue.esm.js", //加上这一句
            }
        },
        output: {
            filename: `gamble/js/[name].${new Date().getTime()}.js`,
            chunkFilename: `gamble/js/[name].${new Date().getTime()}.js`
        }
    },
    // 对内部的 webpack 配置（比如修改、增加Loader选项）(链式操作)
    chainWebpack: () => {},
    // css的处理
    css: {
        //extract: true,        //是否使用css分离插件 ExtractTextPlugin
        sourceMap: false, //开启 CSS source maps
        loaderOptions: {}, //css预设器配置项
        requireModuleExtension: true //启用CSS modules for all css / pre-processor files.
    },
    // 所有 webpack-dev-server 的选项都支持
    devServer: {
        port: 8081,
    },
    // 是否为 Babel 或 TypeScript 使用 thread-loader
    parallel: require('os').cpus().length > 1,
    // 向 PWA 插件传递选项
    pwa: {},
    // 可以用来传递任何第三方插件选项
    pluginOptions: {}
}