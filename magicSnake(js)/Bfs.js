function Bfs(){
  var width = 0;
  var height = 0;
  var maps = [];
  this.initBfs = function(wid,hei,tmaps){
    width = wid;
    height = hei;
    maps = tmaps;
  }

  var visited = [];
  var parents = [];
  var queue = [];

  var dir = [[0,1],[0,-1],[1,0],[-1,0]];

  function init(){
    visited = [];
    parents = [];
    queue = [];
    var i,j;
    for(i=0;i<width;i++){
      visited[i]=[];
      parents[i]=[];
      for(j=0;j<height;j++){
        visited[i][j] = false;
        parents[i][j] = new SnakeNode();
        parents[i][j].x = -1;
        parents[i][j].y = -1;
      }
    }
  }

  function calcBfs(startPos,endPos){
    var tempQue = [];
    tempQue.push(startPos);
    visited[startPos.x][startPos.y] = true;

    var length=0;
    var head,next;
    while(tempQue.length!=0){
      length = tempQue.length;
      while(length--){
        head = tempQue.shift();
        if(head.x == endPos.x && head.y == endPos.y){
          return;
        }
        for(var i=0;i<4;i++){
          next = new SnakeNode(head.x+dir[i][0],head.y+dir[i][1]);
          if(next.x<0 || next.x>(width-1) || next.y<0 || next.y>(height-1) || maps[next.x][next.y])
            continue;
          if(!visited[next.x][next.y]){
            visited[next.x][next.y] = true;
            tempQue.push(next);
            parents[next.x][next.y].x = head.x;
            parents[next.x][next.y].y = head.y;
          }
        }
      }
    }
  }
  function calcQue(endPos){
    if(endPos.x!=-1 && endPos.y!=-1){
      calcQue(parents[endPos.x][endPos.y]);
      queue.push(endPos);
    }
  }

  this.exeBfs = function(startPos,endPos){
    init();
    if(startPos.x>=0 && startPos.x<width && startPos.y>=0 && startPos.y<height &&
       endPos.x>=0 && endPos.x<width && endPos.y>=0 && endPos.y<height)
    {
      calcBfs(startPos,endPos);
      calcQue(endPos);
      queue.shift();
    }
    return queue;
  }

  this.getQueue = function(){
    return queue;
  }
}