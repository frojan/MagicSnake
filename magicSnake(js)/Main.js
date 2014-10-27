function Main(){
  var width = 10, height = 10, sideLen = 60;
  var gameImg =  document.getElementById('gameImg');
  var canvas = document.getElementById('canvas');
  var context = canvas.getContext('2d');
  var backGround; 
  var snake,food,bfs;
  var autoPlay = true;
  var snakeDir = Snake.RIGHT;

  init();

  function init(){
    context.strokeStyle = '#ff0000';
    context.lineWidth = 0.5;
    for(var i=0;i<=width;i++){
      context.beginPath();
      context.moveTo(i*sideLen+0.5,0);
      context.lineTo(i*sideLen+0.5,height*sideLen);
      context.stroke(); 
    }
    for(i=0;i<=height;i++){
      context.beginPath();
      context.moveTo(0,i*sideLen+0.5);
      context.lineTo(width*sideLen,i*sideLen+0.5);
      context.stroke(); 
    }
    backGround = context.getImageData(0,0,canvas.width,canvas.height);

    snake = new Snake(width,height,sideLen);
    food = creatGoodFood();
    bfs = new Bfs();

  }

  function onEnterFrame(){
    if(autoPlay){
      getPathToFood();
      //console.log('walk'+(parseInt(bfs.getQueue().length))+'can eat food');
      if(bfs.getQueue().length == 0 || isSafe() == false){
        getPathToTail();
      }
      var cur = bfs.getQueue().shift();

      var head = snake.nodeArr[snake.nodeArr.length-1];
      if(cur.x == head.x){
        if(cur.y-head.y == 1){
          snakeDir = Snake.DOWN;
        }else if(cur.y-head.y == -1){
          snakeDir = Snake.UP;
        }
      }
      else if(cur.y == head.y){
        if(cur.x-head.x == 1){
          snakeDir = Snake.RIGHT;
        }else if(cur.x-head.x==-1){
          snakeDir = Snake.LEFT;
        }
      }
    }

    if(snake.move(snakeDir,food)){
      if(snake.nodeArr.length == width * height){
        clearInterval(loop);
        drawSnake();
        console.log('map is full');
        alert('GameOver!!!\n\nauthor:Frojan');
        return;
      }
      food = creatGoodFood();
    }

    context.putImageData(backGround,0,0);
    var nodeArr = snake.nodeArr;

    context.fillStyle = '#00ffff';
    context.beginPath();
    context.arc((nodeArr[nodeArr.length-1].x+0.5)*sideLen,(nodeArr[nodeArr.length-1].y+0.5)*sideLen,sideLen/2,0,Math.PI*2);
    context.fill();
    context.fillStyle = '#00ff00';
    //context.fillRect(nodeArr[nodeArr.length-1].x*sideLen,nodeArr[nodeArr.length-1].y*sideLen,sideLen,sideLen);
    context.fillRect(nodeArr[0].x*sideLen,nodeArr[0].y*sideLen,sideLen,sideLen);

    context.fillStyle = '#000000';
    for(var i=1;i<nodeArr.length-1;i++){
      context.fillRect(nodeArr[i].x*sideLen,nodeArr[i].y*sideLen,sideLen,sideLen);
    }
    context.fillStyle = '#ff0000';
    context.fillRect(food.x*sideLen,food.y*sideLen,sideLen,sideLen);
    if(snake.gameOver()){
      clearInterval(loop);
    }
    gameImg.src = canvas.toDataURL();
  }

  var loop = setInterval(onEnterFrame,30);
  function drawSnake(){
    context.putImageData(backGround,0,0);
    var nodeArr = snake.nodeArr;

    context.fillStyle = '#00ffff';
    context.beginPath();
    context.arc((nodeArr[nodeArr.length-1].x+0.5)*sideLen,(nodeArr[nodeArr.length-1].y+0.5)*sideLen,sideLen/2,0,Math.PI*2);
    context.fill();
    context.fillStyle = '#00ff00';
    //context.fillRect(nodeArr[nodeArr.length-1].x*sideLen,nodeArr[nodeArr.length-1].y*sideLen,sideLen,sideLen);
    context.fillRect(nodeArr[0].x*sideLen,nodeArr[0].y*sideLen,sideLen,sideLen);

    context.fillStyle = '#000000';
    for(var i=1;i<nodeArr.length-1;i++){
      context.fillRect(nodeArr[i].x*sideLen,nodeArr[i].y*sideLen,sideLen,sideLen);
    }
    gameImg.src = canvas.toDataURL();
  }
  function creatGoodFood(){
    var food = creatFood();
    var nodeArr = snake.nodeArr;
    for(var i=0;i<nodeArr.length;i++){
      if(nodeArr[i].x == food.x && nodeArr[i].y == food.y){
        food = creatGoodFood();
      }
    }
    return food;
  }
  function creatFood(){
    var x = parseInt(Math.random() * width);
    var y = parseInt(Math.random() * height);

    return new SnakeNode( x,y);
  }
  function getPathToFood(){
    var maps = generalMaps(snake);

    var head = snake.nodeArr[snake.nodeArr.length-1];
    bfs.initBfs(width,height,maps);
    bfs.exeBfs(head,food);
  }
  function getPathToTail(){
    var maps = generalMaps(snake);
    var sta = snake.nodeArr[snake.nodeArr.length-1];
    var end = snake.nodeArr[0];
    bfs.initBfs(width,height,maps);

    var sta_up = new SnakeNode();
    sta_up.x = sta.x;
    sta_up.y = sta.y-1;
    var up = bfs.exeBfs(end,sta_up);
    var sta_down = new SnakeNode();
    sta_down.x = sta.x;
    sta_down.y = sta.y+1;
    var down = bfs.exeBfs(end,sta_down);
    var sta_left = new SnakeNode();
    sta_left.x = sta.x-1;
    sta_left.y = sta.y;
    var left = bfs.exeBfs(end,sta_left);
    var sta_right = new SnakeNode();
    sta_right.x = sta.x+1;
    sta_right.y = sta.y;
    var right = bfs.exeBfs(end,sta_right);
    var temp = [up,down,left,right];
    var max = temp[0];
    for(var i=1;i<4;i++){
      if(max.length>temp[i].length) continue;
      max = temp[i];
    }
    if(max.length == 0){
      bfs.exeBfs(sta,end);
    }else{
      var ssta = max[max.length-1]; 
      bfs.exeBfs(ssta,end);
      bfs.getQueue().unshift(ssta);  
    }
  }
  function isSafe(){
    var queue = bfs.getQueue();
    var tempSnake = snake.clone();
    var head,pathNode;
    var dir='';

    for(var i=0;i<queue.length;i++){
      head = tempSnake.nodeArr[tempSnake.nodeArr.length-1];
      pathNode = queue[i];
      if(pathNode.x == head.x){
        if(pathNode.y-head.y == 1){
          dir = Snake.DOWN;
        }else if(pathNode.y-head.y == -1){
          dir = Snake.UP;
        }
      }
      else if(pathNode.y == head.y){
        if(pathNode.x-head.x == 1){
          dir = Snake.RIGHT;
        }else if(pathNode.x-head.x==-1){
          dir = Snake.LEFT;
        }
      }
      tempSnake.move(dir,food);
    }

    var maps = generalMaps(tempSnake);
    var sta = new SnakeNode(tempSnake.nodeArr[tempSnake.nodeArr.length-1].x,tempSnake.nodeArr[tempSnake.nodeArr.length-1].y);
    var end = new SnakeNode(tempSnake.nodeArr[0].x,tempSnake.nodeArr[0].y);

    var tempBfs = new Bfs();
    tempBfs.initBfs(width,height,maps);
    tempBfs.exeBfs(sta,end);
    if(tempBfs.getQueue().length>0){
      return true;
    }else{
      return false;
    }
  }
  //----生成蛇身数组-----
  function generalMaps(snake){
    var i=0,j;
    var maps=[];
    for(i=0;i<width;i++){
      maps[i] = new Array(height);
      for(j=0;j<height;j++){
        maps[i][j] = false;
      }
    }
    var nodeArr = snake.nodeArr;
    //蛇尾标记为可到达
    for(i=1;i<nodeArr.length;i++){
      maps[nodeArr[i].x][nodeArr[i].y] = true;
    }
    return maps;
  }
}