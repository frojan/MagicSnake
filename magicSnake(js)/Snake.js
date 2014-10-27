function SnakeNode(x,y){
  this.x = x;
  this.y = y;

  this.clone = function(){
    return new SnakeNode(this.x,this.y);
  }
}
function Snake(width,height,sideLen){
  var nodeArr = [];
  this.nodeArr = nodeArr;
  this.currentDir = Snake.RIGHT;

  for(var i=0;i<3;i++){
    nodeArr.push(new SnakeNode(i,0));  
  }

  this.move = function(dir,food){
    if((dir == Snake.UP && this.currentDir == Snake.DOWN)||
       (dir == Snake.DOWN && this.currentDir == Snake.UP)||
       (dir == Snake.LEFT && this.currentDir == Snake.RIGHT)||
       (dir == Snake.RIGHT && this.currentDir == Snake.LEFT)
      ){
      dir = this.currentDir;
    }
    var head = nodeArr[nodeArr.length-1].clone();
    //var head = new SnakeNode(nodeArr[nodeArr.length-1].x,nodeArr[nodeArr.length-1].y);
    switch(dir)
    {
      case Snake.UP:
        head.y -= 1;
        break;
      case Snake.DOWN:
        head.y += 1;
        break;
      case Snake.LEFT:
        head.x -= 1;
        break;
      case Snake.RIGHT:
        head.x += 1;
        break;

    }
    this.currentDir = dir;
    nodeArr.push(head);

    if(head.x == food.x && head.y == food.y){
      return true;
    }else{
      nodeArr.shift();
      return false;
    }

  }
  this.gameOver = function(){
    var head = nodeArr[nodeArr.length-1];
    if(head.x<0 || head.x>=width || head.y<0 || head.y>=height){
      console.log('hit wall,gameOver');
      return true;
    }
    for(var i=0;i<nodeArr.length-1;i++){
      if(head.x == nodeArr[i].x && head.y == nodeArr[i].y){
        console.log('eat self,gameOver');
        return true;
      }
    }
    return false;
  }

  this.clone = function(){
    var snake = new Snake(width,height,sideLen);
    snake.nodeArr.length = 0;
    for(var i=0;i<nodeArr.length;i++){
      snake.nodeArr[i] = new SnakeNode(nodeArr[i].x,nodeArr[i].y);
    }
    snake.currentDir = this.currentDir;
    return snake;
  }
}

Snake.UP = 'up';
Snake.DOWN = 'down';
Snake.LEFT = 'left';
Snake.RIGHT = 'right';