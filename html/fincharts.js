/* charmi liu version 1.0 */
(function(global, factory) {
  typeof exports === 'object' && typeof module !== 'undefined' ? module.exports = factory() :
    typeof define === 'function' && define.amd ? define(factory) :
    (global.barCharts = factory());
}(this, (function() {
  'use strict';

  let SERIES_TYPE = [
    'bar',
    'candlestick',
    'line'
  ];

  /* sample option begin*/
  let oo;
  let cc;
  let hh;
  let ll;

  let option = {
    type: 0,
    X: {
      data: [{
        x: []
      }, {
        x: []
      }]
    },
    Y: {
      data: [{
        title: '中国联通',
        type: 'candle',
        position: 'main',
        kedu: [],
        x: 2,
        y: [{
          type: 'o',
          data: oo
        }, {
          type: 'h',
          data: hh
        }, {
          type: 'l',
          data: ll
        }, {
          type: 'c',
          data: cc
        }, {
          title: 'MA5',
          type: 'line',
          data: cc
        }]
      }, {
        title: 'Vol',
        position: 'sub',
        kedu: [],
        x: 3,
        y: [{
          type: 'bar',
          data: []
        }, {
          type: 'line',
          data: [] // ma5
        }]
      }, {
        title: 'MACD',
        position: 'sub',
        y: [{
          title: 'diff',
          type: 'line',
          data: oo
        }, {
          title: 'dea',
          type: 'line',
          data: cc
        }, {}]
      }]
    }
  };
  /* sample option begin*/

  let O = {
    oo: [],
    hh: [],
    ll: [],
    cc: []
  };

  function stockcharts(opt, theme) {

    let R = Math.round;
    let F = Math.floor;
    let P = []; //记录屏幕px位置对应的K数组下标
    let X, Y;

    /* define G global var !!!! ------------------------------------------------------- */
    let tWid = window.devicePixelRatio;
    let tW = window.innerWidth > 200 ? window.innerWidth : 200, //total width
      H1 = window.innerHeight * 0.60 > 350 ? R(window.innerHeight * 0.60 / 10) * 10 : 350, // candle window height
      H2 = window.innerHeight * 0.35 > 200 ? R(window.innerHeight * 0.35 / 10) * 10 : 200; // MACD KDJ window height
    tW = tW / tWid;
    H1 = H1 / tWid;
    H2 = H2 / tWid;
    let topW = tW,
      botW = tW,
      topH = 0 / tWid,
      botH = 30 / tWid,
      leftW = 60 / tWid,
      rightW = 200 / tWid,
      scrollFH = 15 / tWid,
      scrollBH = 15 / tWid,

      mainFW = tW - rightW - leftW,
      mainFH = H1,
      mainBW = tW - rightW,
      mainBH = H1,

      scrollFW = mainFW,
      scrollBW = mainBW,

      subFW = mainFW,
      subFH = H2,
      subBW = mainBW,
      subBH = H2,

      sttFW = mainFW,
      sttFH = mainFH,
      sttBW = mainBW,
      sttBH = mainBH,

      backFW = mainFW,
      backFH = H1 + topH + scrollFH + H2 * 3 + botH,
      backBW = mainBW,
      backBH = backFH,

      leftH = backFH - topH - botH,
      rightH = backFH - topH - botH;


    let G = {
      AB: [], // levelInit()
      _winX: 0,
      _winY: 0,
      _maxLen: 20000, //  max data len
      _datLen: 0,
      _disLen: 8000, //  max display len
      _disLast: 1, //  display the most right bar !
      _barW: 0,
      _barB: 0,
      _barE: 1000,
      _minLevel: 0, // min display Level
      _curLevel: 0, // current display Level
      _maxLevel: 0 // max display Level
    };

    let cD = []; // canvas Display !!
    let cvsConf = {
      topNav: {
        backgroundColor: "#111111",
        zIndex: 105,
        border: 0,
        top: 0,
        left: 0,
        width: topW,
        height: topH
      },
      leftNav: {
        backgroundColor: "#222222",
        zIndex: 101,
        top: topH,
        left: 0,
        width: leftW,
        height: leftH
      },
      rightNav: {
        backgroundColor: "#222222",
        zIndex: 101,
        top: topH,
        left: tW - rightW,
        width: rightW,
        height: rightH
      },
      botNav: {
        backgroundColor: "#111111",
        zIndex: 105,
        top: backFH - botH,
        left: 0,
        width: botW,
        height: botH
      },
      mainB: {
        backgroundColor: "#000000",
        //backgroundColor: "#776633",
        zIndex: 96,
        top: topH,
        left: 0,
        width: mainBW,
        height: mainBH
      },
      mainF: {
        backgroundColor: "transparent",
        //backgroundColor: "#776633",
        zIndex: 98,
        top: topH,
        left: leftW,
        width: mainFW,
        height: mainFH
      },
      scrollB: {
        backgroundColor: "#229999",
        zIndex: 99,
        top: topH + mainFH,
        left: 0,
        width: scrollBW,
        height: scrollBH
      },
      scrollF: {
        backgroundColor: "#229999",
        zIndex: 100,
        top: topH + mainFH,
        left: leftW,
        width: scrollFW,
        height: scrollFH
      },
      subS: [],
      subB: {
        backgroundColor: "transparent",
        zIndex: 94,
        top: topH + H1 + scrollFH,
        left: 0,
        width: subBW,
        height: subBH
      },
      subF: {
        backgroundColor: "transparent",
        zIndex: 95,
        top: topH + H1 + scrollFH,
        left: leftW,
        width: subFW,
        height: subFH
      },
      sub1B: {
        backgroundColor: "transparent",
        zIndex: 94,
        top: topH + H1 + scrollFH,
        left: 0,
        width: subBW,
        height: subBH
      },
      sub1F: {
        backgroundColor: "transparent",
        zIndex: 95,
        top: topH + H1 + scrollFH,
        left: leftW,
        width: subFW,
        height: subFH
      },
      sub2B: {
        backgroundColor: "transparent",
        zIndex: 12,
        top: topH + H1 + scrollFH + H2,
        left: 0,
        width: subBW,
        height: subBH
      },
      sub2F: {
        backgroundColor: "transparent",
        zIndex: 12,
        top: topH + H1 + scrollFH + H2,
        left: leftW,
        width: subFW,
        height: subFH
      },
      sub3B: {
        backgroundColor: "transparent",
        zIndex: 12,
        top: topH + H1 + scrollFH + H2 * 2,
        left: 0,
        width: subBW,
        height: subBH
      },
      sub3F: {
        backgroundColor: "transparent",
        zIndex: 12,
        top: topH + H1 + scrollFH + H2 * 2,
        left: leftW,
        width: subFW,
        height: subFH
      },
      sttB: {
        backgroundColor: "#222222",
        zIndex: 16,
        top: topH,
        left: 0,
        width: sttBW,
        height: sttBH
      },
      sttF: {
        backgroundColor: "#222222",
        zIndex: 16,
        top: topH,
        left: leftW,
        width: sttFW,
        height: sttFH
      },
      backB: {
        backgroundColor: "#000000",
        zIndex: -101,
        top: 0,
        left: 0,
        width: backBW,
        height: backBH
      },
      backF: {
        backgroundColor: "transparent",
        zIndex: 97,
        top: 0,
        left: leftW,
        width: backFW,
        height: backFH
      }
    }

    /* G definProperties begin         --------------------------*/
    Object.defineProperties(G, {
      "disLast": {
        set: function(x) {
          this._disLast = x;
        },
        get: function() {
          return this._disLast;
        },
        enumerable: true,
        configurable: true
      },
      "curLevel": {
        set: function(x) {
          setCurLevel(x);
        },
        get: function() {
          return this._curLevel;
        },
        enumerable: true,
        configurable: true
      },
      "minLevel": {
        set: function(x) {
          this._minLevel = x;
        },
        get: function() {
          return this._minLevel;
        },
        enumerable: true,
        configurable: true
      },
      "maxLevel": {
        set: function(x) {
          this._maxLevel = x;
        },
        get: function() {
          return this._maxLevel;
        },
        enumerable: true,
        configurable: true
      },
      "barW": {
        set: function(x) {
          this._barW = x;
        },
        get: function() {
          return this._barW;
        },
        enumerable: true,
        configurable: true
      },
      "barB": {
        set: function(x) {
          //this._barB = x;
          setBE(x);
        },
        get: function() {
          return this._barB;
        },
        enumerable: true,
        configurable: true
      },
      "barE": {
        set: function(x) {
          this._barE = x;
        },
        get: function() {
          return this._barE;
        },
        enumerable: true,
        configurable: true
      },
      "maxLen": {
        set: function(x) {
          this._maxLen = x;
        },
        get: function() {
          return this._maxLen;
        },
        enumerable: true,
        configurable: true
      },
      "datLen": {
        set: function(x) {
          this._datLen = x;
        },
        get: function() {
          return this._datLen;
        },
        enumerable: true,
        configurable: true
      },
      "disLen": {
        set: function(x) {
          this._disLen = x;
        },
        get: function() {
          return this._disLen;
        },
        enumerable: true,
        configurable: true
      }
    });

    /* set G._curLevel and modify Begin and End index */
    function setCurLevel(x) {
      if (x < 0) {
        G._curLevel = 0;
      } else if (x > G._maxLevel) {
        G._curLevel = G._maxLevel;
      } else {
        G._curLevel = x;
      }
      console.log(" G._curLevel " + G._curLevel);
      let dataLen = Math.min(G.AB[G._curLevel][2], G._disLen, G._datLen);
      G._barW = G.AB[G._curLevel][0] > 0 ? G.AB[G._curLevel][0] : 1;
      G._barE = R((dataLen + G._barB + G._barE) / 2);
      G._barB = G._barE - dataLen;
      if (G._barB < 0) {
        G._barB = 0;
        G._barE = dataLen;
      };
      if (G._barE >= G._datLen || G._disLast == 1) { //最后一个K柱
        G._barE = G._datLen;
        G._barB = G._datLen - dataLen;
      }
      G._disLast = G._barE == G._datLen ? 1 : 0;
      G._curLen = G._barE - G._barB;
    }

    function setBE(m = 0) {
      let y;
      let x = m - G._barB;
      if (x > 0) {
        y = (G._barE + x) < G._datLen ? x : G._datLen - G._barE;
        G._barE = G._barE + y;
        G._barB = G._barB + y;
      } else if (x < 0) {
        y = m > 0 ? x : 0 - G._barB;
        G._barE = G._barE + y;
        G._barB = G._barB + y;
      }
      G._disLast = G._barE == G._datLen ? 1 : 0;
    }

    function levelInit() {
      let rate = 1.1;
      for (let i = 18; i >= 11; i--) {
        let a1 = 2 * i + 1;
        let sp = R(i / 5);
        G.AB.push([a1, sp, F(mainFW / (a1 + sp))]);
      }
      for (let i = 10; i >= 2; i--) {
        let a1 = 2 * i + 1;
        G.AB.push([a1, 2, F(mainFW / (a1 + 2))]); // 1px 空
        G.AB.push([a1, 1, F(mainFW / (a1 + 1))]);
      }
      let baseLen = mainFW / 5;
      for (let i = 0; i <= 5; i++) {
        G.AB.push([3, 0, F(baseLen)]);
        baseLen = baseLen * rate;
      }
      for (let i = 0; i <= 37; i++) {
        G.AB.push([1, 0, F(baseLen)]);
        baseLen = baseLen * rate;
      }

      G.curLevel = 0;
      G._maxLevel = G.AB.length - 1;
    }
    levelInit();
    /* define G end! ------------------------------------------------------- */


    /* canvas function begin !! ----------------------------------------------- */
    function createCvs(id, c = {}) {
      let canvas = document.createElement("canvas");
      document.body.appendChild(canvas);
      let ctx = canvas.getContext("2d");
      canvas.style.backgroundColor = c.backgroundColor;
      canvas.style.visibility = "visible";
      canvas.style.position = "absolute";
      //canvas.style.border = c.border;
      canvas.style.zIndex = c.zIndex;
      canvas.style.left = c.left;
      canvas.style.top = c.top;
      canvas.width = c.width;
      canvas.height = c.height;
      canvas.id = id;
      return [canvas, ctx, id];
    }

    function _topNav() {
      let cvs = new createCvs("topNav", cvsConf.topNav);
      this.cvs = cvs;
      //cvs[0].style.position = "fixed";
      let ctx = cvs[1];
      ctx.fillStyle = "#AA0000";
      ctx.fillRect(0, topH - 1, topW, 1);
    }

    function _leftNav() {
      let cvs = new createCvs("leftNav", cvsConf.leftNav);
      this.cvs = cvs;
      //cvs[0].style.position = "fixed";
      let ctx = cvs[1];
      ctx.fillStyle = "#AA0000";
      ctx.fillRect(0, topH + 200, leftW, 1);
    }
    //let leftNav = new _leftNav();

    function _rightNav() {
      let cvs = new createCvs("rightNav", cvsConf.rightNav);
      this.cvs = cvs;
      //cvs[0].style.position = "fixed";
    }

    function _botNav() {
      let cvs = new createCvs("botNav", cvsConf.botNav);
      this.cvs = cvs;
    }

    function _mainF() {
      let c = new createCvs("mainF", cvsConf.mainF);
      this.cvs = c[0];
      this.ctx = c[1];
      this.id = c[2];
      this.mn = [];
      //cvs[0].style.position = "fixed";
      this.cvs.addEventListener("mousemove", mouseMove, false);
      this.cvs.addEventListener("mouseleave", mouseMove, false);
      //cvs.addEventListener("mouseout", mouseMove, false);
      this.cvs.addEventListener('wheel', xxxx, false);
      //this.ctx.fillStyle = "#773388";
      //this.ctx.fillRect(0, 100, 500, 20);
    }

    function _mainB() {
      let c = new createCvs("mainB", cvsConf.mainB);
      this.cvs = c[0];
      this.ctx = c[1];
      this.kedu = [];
      this.mn = [];
      //cvs[0].style.position = "fixed";
      c[0].addEventListener("mousemove", mouseMove, false);
      c[0].addEventListener('wheel', xxxx, false);

      this.init = function() {
        c[1].fillStyle = "#773388";
        this.kedu.push([30, "100%"]);
        this.kedu.push([R(30 + (mainBH - 60) * 0.191), "19.1%"]);
        this.kedu.push([R(30 + (mainBH - 60) * 0.382), "38.2%"]);
        this.kedu.push([R(30 + (mainBH - 60) * 0.500), "50.0%"]);
        this.kedu.push([R(30 + (mainBH - 60) * 0.618), "61.8%"]);
        this.kedu.push([R(30 + (mainBH - 60) * 0.809), "80.9%"]);
        this.kedu.push([mainBH - 30, "00.0%"]);

        c[1].fillStyle = "#773388";
        c[1].font = "14px";
        c[1].fillRect(leftW - 2, 0, 1, mainBH);
        for (let i = 0; i < this.kedu.length; i++) {
          c[1].fillStyle = "#773388";
          c[1].fillRect(leftW - 6, this.kedu[i][0], 4, 1);
          c[1].fillStyle = "#222222";
          c[1].fillRect(leftW - 1, this.kedu[i][0], mainBW - leftW, 1);
          c[1].fillStyle = "#AAAAAA";
          c[1].fillText(this.kedu[i][1], leftW - 38, this.kedu[i][0]);
        }
      }
      this.init();
    }


    function _scrollB() {
      let cvs = new createCvs("scrollB", cvsConf.scrollB);
      this.cvs = cvs;
      //cvs[0].style.position = "fixed";
    }

    function _scrollF() {
      let cvs = new createCvs("scrollF", cvsConf.scrollF);
      this.cvs = cvs;
      //cvs[0].style.position = "fixed";
    }

    function _subB() {
      let c = new createCvs("subB", cvsConf.subB);
      this.cvs = c[0];
      this.ctx = c[1];
      this.kedu = [];
      //cvs[0].style.position = "fixed";
      c[0].addEventListener("mousemove", mouseMove, false);
      c[0].addEventListener('wheel', xxxx, false);

      this.init = function() {
        this.ctx.fillStyle = "#AA0000";
        this.ctx.fillRect(0, subBH - 1, subBW, 1);
        c[1].fillStyle = "#773388";
        this.kedu.push([30, "100%"]);
        this.kedu.push([R(30 + (subBH - 60) * 0.191), "19.1%"]);
        this.kedu.push([R(30 + (subBH - 60) * 0.382), "38.2%"]);
        this.kedu.push([R(30 + (subBH - 60) * 0.500), "50.0%"]);
        this.kedu.push([R(30 + (subBH - 60) * 0.618), "61.8%"]);
        this.kedu.push([R(30 + (subBH - 60) * 0.809), "80.9%"]);
        this.kedu.push([subBH - 30, "00.0%"]);

        c[1].fillStyle = "#773388";
        c[1].font = "14px";
        c[1].fillRect(leftW - 2, 0, 1, subBH);
        for (let i = 0; i < this.kedu.length; i++) {
          c[1].fillStyle = "#773388";
          c[1].fillRect(leftW - 6, this.kedu[i][0], 4, 1);
          c[1].fillStyle = "#222222";
          c[1].fillRect(leftW - 1, this.kedu[i][0], subBW - leftW, 1);
          c[1].fillStyle = "#AAAAAA";
          c[1].fillText(this.kedu[i][1], leftW - 38, this.kedu[i][0]);
        }
      }
      this.init();
    }

    function _subF() {
      let c = new createCvs("subF", cvsConf.subF);
      this.cvs = c[0];
      this.ctx = c[1];
      this.ctx.fillStyle = "#AA0000";
      this.ctx.fillRect(0, subFH - 1, subFW, 1);
      this.cvs.addEventListener("mousemove", mouseMove, false);
      this.cvs.addEventListener('wheel', xxxx, false);
    }


    function _stt() {
      let cvs = new createCvs("stt", cvsConf.stt);
      this.cvs = cvs;
      cvs[0].addEventListener("mousemove", mouseMove, false);
      cvs[0].addEventListener('wheel', xxxx, false);
    }

    function _backF() {
      let c = new createCvs("backF", cvsConf.backF);
      this.cvs = c[0];
      this.ctx = c[1];
      //cvs[0].style.position = "fixed";
      this.mouseMove = function(x, y) {
        c[1].clearRect(0, 0, backFW, backFH);
        c[1].fillStyle = "#773388";
        c[1].fillRect(x, 0, 1, backFH);
        c[1].fillRect(0, y, backFW, 1);
      }
    }

    function _backB() {
      let c = new createCvs("backB", cvsConf.backB);
      this.cvs = c[0];
      this.ctx = c[1];
      //cvs[0].style.position = "fixed";
      this.mouseMove = function(x, y) {
        c[1].clearRect(0, 0, backBW, backBH);
        c[1].fillStyle = "#773388";
        c[1].fillRect(x, 0, 1, 600);
        c[1].fillRect(0, y, 1200, 1);
      }
    }

    let topNav = new _topNav();
    let rightNav = new _rightNav();
    let botNav = new _botNav();
    //let mainF = new _mainF();
    //let mainB = new _mainB();
    let scrollB = new _scrollB();
    let scrollF = new _scrollF();
    //let sub1B = new _subB();
    //let sub1F = new _subF();
    let backF = new _backF();
    let backB = new _backB();
    /* canvas function end !! ----------------------------------------------- */

    function OInit(opt = {}, O = {}) {
      //O = opt;
      if (opt.X) {
        O.X = opt.X;
      }
      if (opt.Y) {
        O.Y = opt.Y;
        O.oo = O.Y.data[0].oo; // 是同一个，不是新创建O.oo
        O.hh = O.Y.data[0].hh;
        O.ll = O.Y.data[0].ll;
        O.cc = O.Y.data[0].cc;
      }
      G.curLevel = 0;
      //G.curLevel = G.curLevel ;  //这个赋值，用来更新 G.barB B.barE !!
    }

    this.update = function(opt) {
      if (opt.type == 1) { //更新，但最后一个只是修改
        for (let i = 0; i < opt.Y.data.length; i++) {
          if (opt.Y.data[i].position == 'main') {
            for (let j = 0; j < opt.Y.data[i].y.length; j++) {
              cD[i][0].y[j].data.pop();
              for (let k = 0; k < opt.Y.data[i].y[j].data.length; k++) {
                cD[i][0].y[j].data.push(opt.Y.data[i].y[j].data[k]);
              }
            }
            let n = 0;
            for (let j = 0; j < cD[i][0].y.length; j++) {
              if (cD[i][0].y[j].type == 'o') {
                cD[i][0].oo = cD[i][0].y[j].data;
                G.datLen = cD[i][0].oo.length;
              } else if (cD[i][0].y[j].type == 'h') {
                cD[i][0].hh = cD[i][0].y[j].data;
                cD[i][0].ll = cD[i][0].y[j].data;
              } else if (cD[i][0].y[j].type == 'c') {
                cD[i][0].cc = cD[i][0].y[j].data;
              } else {
                cD[i][0].other[n] = cD[i][0].y[j];
                n++;
              }
            }
          }
          if (opt.Y.data[i].position == 'sub') {}
        }

        G.curLevel = G.curLevel;
        drawAll();
      } else if (opt.type == 2) { // 更新，最后一个不再修改
        for (let i = 0; i < opt.Y.data.length; i++) {
          if (opt.Y.data[i].position == 'main') {
            for (let j = 0; j < opt.Y.data[i].y.length; j++) {
              for (let k = 0; k < opt.Y.data[i].y[j].data.length; k++) {
                cD[i][0].y[j].data.push(opt.Y.data[i].y[j].data[k]);
              }
            }
            let n = 0;
            for (let j = 0; j < cD[i][0].y.length; j++) {
              if (cD[i][0].y[j].type == 'o') {
                cD[i][0].oo = cD[i][0].y[j].data;
                G.datLen = cD[i][0].oo.length;
              } else if (cD[i][0].y[j].type == 'h') {
                cD[i][0].hh = cD[i][0].y[j].data;
              } else if (cD[i][0].y[j].type == 'l') {
                cD[i][0].ll = cD[i][0].y[j].data;
              } else if (cD[i][0].y[j].type == 'c') {
                cD[i][0].cc = cD[i][0].y[j].data;
              } else {
                cD[i][0].other[n] = cD[i][0].y[j];
                n++;
              }
            }
          }
          if (opt.Y.data[i].position == 'sub') {}
        }
        //alert("G.datLen " + G.datLen);
        //alert( "O.oo.length: " + O.oo.length );
        G.curLevel = G.curLevel;
        drawAll();
      } else if (opt.type == 0) { //完全更新，不要以前的数据了
        for (let i = 0; i < opt.Y.data.length; i++) {
          if (opt.Y.data[i].position == 'main') {
            let mF = new _mainF();
            let mB = new _mainB();
            mF.y = opt.Y.data[i].y;
            let n = 0;
            mF.other = [];
            for (let j = 0; j < mF.y.length; j++) {
              if (mF.y[j].type == 'o') {
                mF.oo = mF.y[j].data;
                O.oo = mF.oo;
                G.datLen = mF.oo.length;
              } else if (mF.y[j].type == 'h') {
                mF.hh = mF.y[j].data;
                O.hh = mF.hh;
              } else if (mF.y[j].type == 'l') {
                mF.ll = mF.y[j].data;
                O.ll = mF.ll;
              } else if (mF.y[j].type == 'c') {
                mF.cc = mF.y[j].data;
                O.cc = mF.cc;
              } else {
                mF.other[n] = opt.Y.data[i].y[j];
                n++;
              }
            }
            cD.push([mF, mB]);
          }
          if (opt.Y.data[i].position == 'sub') {
            let subF = new _subF();
            let subB = new _subB();
            subF.Y = opt.Y.data[i].y;
            cD.push([subF, subB]);
          }
        }
        //O.oo = opt.Y.data[0].y[0].data; // 是同一个，不是新创建O.oo
        //O.hh = opt.Y.data[0].y[1].data;
        //O.ll = opt.Y.data[0].y[2].data;
        //O.cc = opt.Y.data[0].y[3].data;
        G.curLevel = 0;
      }
      let subbB = Object.create(cvsConf.subB);
      let subbF = Object.create(cvsConf.subB);
      cvsConf.subS.push([subbB, subbF]);

      //drawAll();

    }

    this.update(opt);
    let mainF = cD[0][0];
    let mainB = cD[0][1];
    let sub1F = cD[1][0];
    let sub1B = cD[1][1];

    console.log(cvsConf.subS);
    console.log(cD);
    console.log(cD[1][0].Y);
    console.log(cD[0] instanceof _mainF);
    console.log(cD[1] instanceof _mainF);
    console.log(cD[1] instanceof _mainB);



    //console.log(Object.entries(opt));


    function _initMA(N, cc) {
      let i = 0;
      let sum = 0;
      let aver;
      let rr = [];
      if (N <= 0) {
        return -1;
      }
      for (i = 0; i < N - 1; i++) {
        sum = cc[i] + sum;
        rr.push(0);
      }
      if (N == cc.length) {
        sum = sum + cc[N - 1];
        rr.push(R(sum / N * 1000) / 1000);
        i = i + 1;
      } else if (N < cc.length) {
        sum = sum + cc[N - 1];
        rr.push(R(sum / N * 1000) / 1000);
        for (i = N; i < cc.length; i++) {
          sum = sum - cc[i - N] + cc[i];
          aver = R(sum / N * 1000) / 1000;
          rr.push(aver);
        }
      }
      return {
        MA: rr,
        sum: (sum-cc[i-1]), // 前N-1的合值
        idx: i - 1 // cc.length-1
      };
    }

    function _MA(N, cc) {
      let r = new _initMA(N, cc);
      this.MA = r.MA;
      this.sum = r.sum;
      this.idx = r.idx; // length-1 
      this.calcMA = function(x) { // x should be length-1
        if( x >= cc.length ) { x = cc.length-1; }
        //console.log("this.idx:" + this.idx + " x: " + x);
        if (x < this.idx) {
          return;
        } else if (x >= this.idx) {
          //console.log("N:i  " + N );
          this.sum = this.sum + cc[this.idx];
          this.MA.pop();
          this.MA.push(R(this.sum / N * 1000) / 1000);
          for (let i = this.idx + 1; i <= x; i++) {
            this.sum = this.sum - cc[i - N] + cc[i];
            this.MA.push(R(this.sum / N * 1000) / 1000);
          }
          this.idx = x;
          this.sum = this.sum - cc[x];
        }
      }
    }



    function calcYkedu(height, b, e, hh, ll) {
      //let top = 0.05;
      //let down = 0.95;
      let top = 30;
      let down = 30;
      let h = [];
      h = hh.slice(b, e);
      let l = [];
      if (ll == undefined) {
        l = h;
      } else {
        l = ll.slice(b, e);
      }
      let hmax = Math.max.apply(null, h);
      let lmin = Math.min.apply(null, l);
      //let m = (height * (top - down)) / (hmax - lmin);
      let m = (top + down - height) / (hmax - lmin);
      //let n = height * down - m * lmin;
      let n = height - down - m * lmin;
      let kedu = [];
      kedu.push([R(top), hmax]);
      kedu.push([R(height - down), lmin]);
      return [m, n];
    }

    function calcYkedu0(height, hh, ll) {
      let top = 30;
      let down = 30;
      if (ll == undefined) {
        ll = hh;
      }
      let hmax = Math.max.apply(null, hh);
      let lmin = Math.min.apply(null, ll);
      let m = (top + down - height) / (hmax - lmin);
      let n = height - down - m * lmin;
      return [m, n];
    }

    /*---------------------------------------------------------------------------------------------- */
    //OInit(opt, O);
    //this.initHL();
    //calcYkedu1(100, 5, 100, O.hh, O.ll, G.hFst, G.lFst, G.hSnd, G.lSnd);
    //console.log(G.hFst);
    //console.log(G.lFst);

    let MA5 = new _MA(5, O.cc);
    let MA10 = new _MA(10, O.cc);
    let MA20 = new _MA(20, O.cc);
    let MA30 = new _MA(30, O.cc);
    let MA40 = new _MA(40, O.cc);
    let MA60 = new _MA(60, O.cc);
    let MA89 = new _MA(89, O.cc);
    let MA144 = new _MA(144, O.cc);
    let MA233 = new _MA(233, O.cc);
    let MA377 = new _MA(377, O.cc);
    let MA610 = new _MA(610, O.cc);

    /* ----------------------------------------------------------------------------------------------------*/





    function drawLine(obj, dd, color) {
      let ctx = obj.ctx;
      let j = 0;
      let x1, y1;
      let x2, y2;
      let start;
      ctx.beginPath();
      for (let i = G.barB; i < G.barE; i++) {
        if (dd[i] != 0) {
          start = i;
          break;
        }
      }
      let v = R(obj.mn[0] * dd[start] + obj.mn[1]);
      x1 = P[start - G.barB] + 0.5;
      y1 = v + 0.5;
      ctx.moveTo(x1, y1);
      for (let i = start + 1; i < G.barE; i++) {
        /* 
           while (P[i - G.barB] == P[start - G.barB]) {
             i++;
           }
           */

        v = R(obj.mn[0] * dd[i] + obj.mn[1]);
        x2 = P[i - G.barB] + 0.5;
        y2 = v + 0.5;

        ctx.lineTo(x2, y2);
        x1 = x2;
        y1 = y2;

      }
      ctx.strokeStyle = color;
      ctx.stroke();
      ctx.closePath();
    }


    function drawCandle(obj) {
      let oo = [],
        hh = [],
        ll = [],
        cc = [];
      let idxB;
      let idxE;
      let posB;
      let position,
        halfBarW = (G.barW - 1) / 2;
      let cvs = obj.cvs;
      let ctx = obj.ctx;
      ctx.clearRect(0, 0, cvs.width, cvs.height);

      let o, h, l, c, dif1, dif2;
      let PP = [];

      P.length = 0;

      posB = -1;
      idxB = G.barB;

      for (let i = G.barB; i < G.barE; i++) {
        position = F(((i - G.barB) / G.AB[G.curLevel][2]) * cvs.width);
        P[i - G.barB] = position + halfBarW;
        if (position == posB && i != (G.barE - 1)) {
          continue;
        } else {
          let h1 = O.hh.slice(idxB, i + 1)
          let l1 = O.ll.slice(idxB, i + 1)
          let hhh = Math.max.apply(null, h1);
          let lll = Math.min.apply(null, l1);

          hh.push(hhh);
          ll.push(lll);
          oo.push(O.oo[idxB]);
          cc.push(O.cc[i]);

          PP.push(position + halfBarW);

          posB = position;
          idxB = i + 1;
        }
      }
      obj.mn = calcYkedu0(cvs.height, hh, ll);
      for (let i = 0; i < hh.length; i++) {
        if (halfBarW != 0) {
          o = R(obj.mn[0] * oo[i] + obj.mn[1]);
          c = R(obj.mn[0] * cc[i] + obj.mn[1]);
          dif1 = c - o;
          if (dif1 == 0) {
            dif1 = 1;
          }
        }
        h = R(obj.mn[0] * hh[i] + obj.mn[1]);
        l = R(obj.mn[0] * ll[i] + obj.mn[1]);
        dif2 = l - h;
        if (dif2 == 0) {
          dif2 = 1;
        }

        if (cc[i] < oo[i]) {
          ctx.fillStyle = "#008888";
          if (halfBarW != 0) {
            ctx.fillRect(PP[i] - halfBarW, o, G.barW, dif1);
            ctx.fillRect(PP[i], h, 1, dif2);
          } else {
            ctx.fillRect(PP[i], h, 1, dif2);
          }
        } else {
          ctx.fillStyle = "#880000";
          if (halfBarW != 0) {
            ctx.fillRect(PP[i] - halfBarW, c, G.barW, 0 - dif1);
            ctx.fillRect(PP[i], h, 1, dif2);
          } else {
            ctx.fillRect(PP[i], h, 1, dif2);
          }
        }
      }
      drawLine(obj, MA5.MA, "#E7E7E7");
      drawLine(obj, MA10.MA, "#DCDC0A");
      drawLine(obj, MA20.MA, "#FF00FF");
      drawLine(obj, MA30.MA, "#FF0000");
      drawLine(obj, MA40.MA, "#00F000");
      drawLine(obj, MA60.MA, "#787878");
      drawLine(obj, MA89.MA, "#FF0000");
      drawLine(obj, MA144.MA, "#FF8000");
      drawLine(obj, MA233.MA, "#808000");
      drawLine(obj, MA377.MA, "#800080");
      drawLine(obj, MA610.MA, "#008080");
    }


    this.drawCandle0 = function() {
      //   position = F(F(x * G.AB[G.curLevel][2] / mainFW) * mainFW / G.AB[G.curLevel][2]);
      /*
         反求：
         如果 G.AB[G.curLevel][2] 比 mainFW 小的话：
         position = F(F(x * G.AB[G.curLevel][2] / mainFW) * mainFW / G.AB[G.curLevel][2]);
         x:在屏上取得的X坐标
      */
    }

    function drawAll() {
      MA5.calcMA(G.datLen);
      MA10.calcMA(G.datLen);
      MA20.calcMA(G.datLen);
      MA30.calcMA(G.datLen);
      MA40.calcMA(G.datLen);
      MA60.calcMA(G.datLen);
      MA89.calcMA(G.datLen);
      MA144.calcMA(G.datLen);
      MA233.calcMA(G.datLen);
      MA377.calcMA(G.datLen);
      MA610.calcMA(G.datLen);
      drawCandle(cD[0][0]);

      let uu = MA5.MA.slice(G.barB, G.barE);
      sub1F.mn = calcYkedu0(sub1F.cvs.height, uu, uu);
      sub1F.ctx.clearRect(0, 0, subFW, subFH);
      //drawLine(sub1F, MA60.MA, "#787878");
      //drawLine(sub1F, MA30.MA, "#787878");
      drawLine(cD[1][0], MA10.MA, "#787878");
    }

    /* -------------------------------------------------------------------------------------------------------------------------- */

    function keyPress(e) {
      let keyID = e.keyCode ? e.keyCode : e.which;
      if (keyID === 38 || keyID === 87) { // up arrow and W
        if (G.curLevel > 0) {
          G.curLevel = G.curLevel - 1;
          drawAll();
        }
        e.preventDefault();
      }
      if (keyID === 40 || keyID === 83) { // down arrow and S
        if (G.curLevel < G.maxLevel) {
          G.curLevel = G.curLevel + 1;
          drawAll();
        }
        e.preventDefault();
      }
      if (keyID === 37 || keyID === 65) { // left arrow and A
        //setBE(-G.curLevel);
        G.barB = G.barB - G.curLevel;
        drawAll();
        e.preventDefault();
      }
      if (keyID === 39 || keyID === 68) { // right arrow and D
        /*
          if (G.barE < O.hh.length) {
         G.barE++;
         G.barB++;
        };
       */
        //setBE(G.curLevel);
        G.barB = G.barB + G.curLevel;
        drawAll();
        e.preventDefault();
      }
    }

    function xxxx(e) {
      console.log(e.deltaX);
      console.log(e.deltaY);
      if (e.deltaY > 0) { // 向下
        G.barB = G.barB - 50;
      } else {
        G.barB = G.barB + 50;
      }
      drawAll();
      e.preventDefault();
    }

    function mouseMove(e) {
      let mousePos = getMousePos(backF.cvs, e);
      // console.log(mousePos);
      //show1(mousePos.x, mousePos.y);
      backF.mouseMove(mousePos.x, mousePos.y);
    }


    backF.cvs.addEventListener("mousemove", mouseMove, false);

    function getMousePos(cvs, e) {
      let r = cvs.getBoundingClientRect();
      return {
        x: e.clientX - r.left * (cvs.width / r.width),
        y: e.clientY - r.top * (cvs.height / r.height)
      }
    }


    cvs.addEventListener('keydown', keyPress, true);
    cvs.focus();
    // key eee - use window as object
    window.addEventListener('keydown', keyPress, true);

    //cvs.addEventListener("mousedown", doMouseDown, false);
    //cvs.addEventListener('mousemove', doMouseMove, false);
    //cvs.addEventListener('mouseup', doMouseUp, false);
    cvs.addEventListener('wheel', xxxx, false);
    //cvs.addEventListener("mousemove", yyyy, false);
    //cvs.addEventListener("click", kkkkk, false);

    drawAll();
  }
  return stockcharts;
})));
