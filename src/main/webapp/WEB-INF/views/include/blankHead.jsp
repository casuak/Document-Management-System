<%@ page contentType="text/html;charset=UTF-8" %>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="/static/plugins/bootstrap-3.3.7-dist/css/bootstrap.min.css"/>

<link rel="stylesheet" href="/static/plugins/element-ui@2.4.11/lib/theme-chalk/index.css">

<link rel="stylesheet" href="/static/plugins/iview/styles/iview.css"/>

<link rel="stylesheet" href="/static/plugins/font-awesome-4.7.0/css/font-awesome.min.css">

<style>
    [v-cloak] {
        display: none;
    }

    html{
        height: 100%;
    }

    body {
        height: 100%;
    }

    #app{
        height: 100%;
    }

    * {
        box-sizing: border-box;
    }

    /* 以下是滚动轴样式 */
    .scroll-bar{
        overflow-y: auto;
        scrollbar-base-color: transparent;
        scrollbar-darkshadow-color: transparent;
        scrollbar-highlight-color: transparent;
        scrollbar-face-color: transparent;
    }

    ::-webkit-scrollbar { /*滚动条整体样式*/
        width: 5px; /*高宽分别对应横竖滚动条的尺寸*/
        height: 1px;
    }

    ::-webkit-scrollbar-thumb { /*滚动条里面小方块*/
        border-radius: 100px;
        -webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.2);
        background: rgba(83, 83, 83, 0.27);
    }

    /*::-webkit-scrollbar-track { !*滚动条里面轨道*!*/
        /*-webkit-box-shadow: inset 0 0 5px rgba(0, 0, 0, 0);*/
        /*border-radius: 10px;*/
        /*background: rgba(237, 237, 237, 0);*/
    /*}*/
    /* 以上是滚动轴样式 */

</style>