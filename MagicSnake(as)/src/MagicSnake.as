package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import Bfs.Bfs;
	import Bfs.PointNode;
	
	import core.Snake;
	import core.SnakeNode;
	
	import utils.Lists;
	
	[SWF(width="400",height="400",backgroundColor="#ffffff")]
	
	/**
	 * 不死的小蛇，^_^
	 * @author Frojan 
	 */
	public class MagicSnake extends Sprite
	{
		private var root:Sprite;
		
		//地图的大小
		private var width:int;
		private var height:int;
		private var sideLen:int;
		
		private var snake:Snake;
		private var snakeDir:String;//蛇头的方向
		
		private var snakeGraphics:Graphics;
		private var timer:Timer;
		
		private var food:Rectangle;//食物
		private var bfsPath:Bfs;
		private var autoPlay:Boolean=true;
		
		public function MagicSnake()
		{
			init();
		}
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			
			width = 10;
			height = 10;
			sideLen = 20;
			root = new Sprite();
			root.x = 100;
			root.y = 100;
			this.addChild(root);
			
			var background:Sprite = new Sprite();
			background.graphics.beginFill(0xcccccc);
			background.graphics.drawRect(0,0,width*sideLen,height*sideLen);
			
			background.graphics.lineStyle(.1,0xaa0000);
			var i:int=0;
			for(i=0;i<=width;i++){
				background.graphics.moveTo(i*sideLen,0);
				background.graphics.lineTo(i*sideLen,height*sideLen);
			}
			for(i=0;i<=height;i++){
				background.graphics.moveTo(0,i*sideLen);
				background.graphics.lineTo(width*sideLen,i*sideLen);
			}
			background.graphics.endFill();
			root.addChild(background);
			
			var snakeSprite:Sprite = new Sprite();
			snakeGraphics = snakeSprite.graphics;
			root.addChild(snakeSprite);
			
			snakeDir = Snake.RIGHT;
			snake = new Snake(width,height,sideLen);
			food = creatGoodFood();
			
			bfsPath = new Bfs();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			timer = new Timer(30);
			timer.addEventListener(TimerEvent.TIMER,onMoving);
			timer.start();
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					snakeDir = Snake.UP;
					break;
				case Keyboard.DOWN:
					snakeDir = Snake.DOWN;
					break;
				case Keyboard.LEFT:
					snakeDir = Snake.LEFT;
					break;
				case Keyboard.RIGHT:
					snakeDir = Snake.RIGHT;
					break;
			}
		}
		
		private function onMoving(event:TimerEvent):void
		{
			if(autoPlay){
				getPathToFood();
				//保证每一次进食后蛇头与蛇尾之间有路径
				if(bfsPath.queue.length==0 || !isSafe()){
					//此时蛇头和蛇尾之间肯定有路径，跟蛇尾走
					getPathToTail();
				}
				var cur:PointNode = PointNode(bfsPath.queue.head); 
				bfsPath.queue.delete_head();  
				
				var rc:Rectangle = SnakeNode(snake.snakeList.head).rec;  
				var headPoint:PointNode = new PointNode();  
				headPoint.x = rc.x/sideLen;  
				headPoint.y = rc.y/sideLen;  
				if(cur.x==headPoint.x)  
				{  
					if(cur.y-headPoint.y==1)  
						snakeDir=Snake.DOWN;  
					else if(cur.y-headPoint.y==-1)  
						snakeDir=Snake.UP;  
				}  
				else if(cur.y==headPoint.y)  
				{  
					if(cur.x-headPoint.x==1)  
						snakeDir=Snake.RIGHT;  
					else if(cur.x-headPoint.x==-1)  
						snakeDir=Snake.LEFT;  
				}  
			}
			if(snake.move(snakeDir,food)){
				if(snake.snakeList.length == width*height){
					timer.stop();
					return;
				}
				food = creatGoodFood();
			}
			
			var head:SnakeNode = SnakeNode(snake.snakeList.head);
			snakeGraphics.clear();
			snakeGraphics.beginFill(0x0000ff);
			snakeGraphics.drawCircle(head.rec.x+sideLen/2,head.rec.y+sideLen/2,sideLen/2);
			head = SnakeNode(head.next);
			snakeGraphics.beginFill(0x000000);
			while(head)
			{
				snakeGraphics.drawRect(head.rec.x,head.rec.y,head.rec.width,head.rec.height);
				head = SnakeNode(head.next);
			}
			snakeGraphics.beginFill(0x00ff00);
			snakeGraphics.drawRect(SnakeNode(snake.snakeList.back).rec.x,SnakeNode(snake.snakeList.back).rec.y,sideLen,sideLen);
			
			snakeGraphics.beginFill(0xff0000);
			snakeGraphics.drawRect(food.x,food.y,food.width,food.height);
			snakeGraphics.endFill();
			
			if(snake.gamaOver()){
				timer.stop();
			}
		}
		
		private function creatFood():Rectangle
		{
			var px:int = Math.random() * width;
			var py:int = Math.random() * height;
			
			return new Rectangle(px*sideLen,py*sideLen,sideLen,sideLen);
		}
		/**
		 * 随机生成，若与蛇身重合则再随机一次，这种方法比较简单，可以用更好的办法。 
		 * @return 
		 * 
		 */
		private function creatGoodFood():Rectangle
		{
			var rec:Rectangle = creatFood();
			var head:SnakeNode = SnakeNode(snake.snakeList.head);
			while(head)
			{
				if(head.rec.x == rec.x && head.rec.y == rec.y){
					rec = creatGoodFood();
					return rec;
				}
				head = SnakeNode(head.next);
			}
			return rec;
		}
		
		/**
		 * 获得蛇头到食物的路径 ，最短
		 */
		private function getPathToFood():void{
			var maps:Vector.<Vector.<Boolean>> = generalMaps(snake);
			
			var head:SnakeNode = SnakeNode(snake.snakeList.head);
			var sta:PointNode = new PointNode();
			var end:PointNode = new PointNode();
			sta.x = head.rec.x/sideLen;
			sta.y = head.rec.y/sideLen;
			end.x = food.x/sideLen;
			end.y = food.y/sideLen;
			bfsPath.initBfs(width,height,maps);
			bfsPath.exeBfs(sta,end);
		}
		
		/**
		 * 获得蛇头到蛇尾的路径 ，最长
		 */
		private function getPathToTail():void{
			var maps:Vector.<Vector.<Boolean>> = generalMaps(snake);
			
			var sta:PointNode = new PointNode();
			var end:PointNode = new PointNode();
			sta.x = SnakeNode(snake.snakeList.head).rec.x/sideLen;
			sta.y = SnakeNode(snake.snakeList.head).rec.y/sideLen;
			end.x = SnakeNode(snake.snakeList.back).rec.x/sideLen;
			end.y = SnakeNode(snake.snakeList.back).rec.y/sideLen;
			bfsPath.initBfs(width,height,maps);
			
			var sta_up:PointNode = new PointNode();
			sta_up.x = sta.x;
			sta_up.y = sta.y-1;
			var up:Lists = bfsPath.exeBfs(end,sta_up);
			var sta_down:PointNode = new PointNode();
			sta_down.x = sta.x;
			sta_down.y = sta.y+1;
			var down:Lists = bfsPath.exeBfs(end,sta_down);
			var sta_left:PointNode = new PointNode();
			sta_left.x = sta.x-1;
			sta_left.y = sta.y;
			var left:Lists = bfsPath.exeBfs(end,sta_left);
			var sta_right:PointNode = new PointNode();
			sta_right.x = sta.x+1;
			sta_right.y = sta.y;
			var right:Lists = bfsPath.exeBfs(end,sta_right);
			var temp:Vector.<Lists> = Vector.<Lists>([up,down,left,right]);
			var max:Lists = temp[0];
			for(var i:int=1;i<4;i++){
				if(max.length>temp[i].length) continue;
				max = temp[i];
			}
			if(max.length == 0){
				bfsPath.exeBfs(sta,end);
			}else{
				bfsPath.exeBfs(PointNode(max.back),end);
				bfsPath.queue.push_head(max.back);
				
			}
		}
		
		/**
		 * 判断真蛇吃到食物后是否与蛇尾有同路，有则表示安全
		 */
		private function isSafe():Boolean{
			var cur:PointNode = PointNode(bfsPath.queue.head);
			var tempSnake:Snake = snake.clone();
			var dir:String;
			while(cur){
				var rc:Rectangle = SnakeNode(tempSnake.snakeList.head).rec;  
				var headPoint:PointNode = new PointNode();  
				headPoint.x = rc.x/sideLen;  
				headPoint.y = rc.y/sideLen;  
				if(cur.x==headPoint.x)  
				{  
					if(cur.y-headPoint.y==1)  
						dir=Snake.DOWN;  
					else if(cur.y-headPoint.y==-1)  
						dir=Snake.UP;  
				}  
				else if(cur.y==headPoint.y)  
				{  
					if(cur.x-headPoint.x==1)  
						dir=Snake.RIGHT;  
					else if(cur.x-headPoint.x==-1)  
						dir=Snake.LEFT;  
				}  
				cur = PointNode(cur.next);
				
				tempSnake.move(dir,food)
			}
			
			//检测模拟蛇的头部和尾部是否存在路径
			var maps:Vector.<Vector.<Boolean>> = generalMaps(tempSnake);
			
			var sta:PointNode = new PointNode();
			var end:PointNode = new PointNode();
			sta.x = SnakeNode(tempSnake.snakeList.head).rec.x/sideLen;
			sta.y = SnakeNode(tempSnake.snakeList.head).rec.y/sideLen;
			//			trace("模拟蛇头位置:"+sta.x+","+sta.y);
			end.x = SnakeNode(tempSnake.snakeList.back).rec.x/sideLen;
			end.y = SnakeNode(tempSnake.snakeList.back).rec.y/sideLen;
			//			trace("模拟蛇尾位置:"+end.x+","+end.y);
			var bfs:Bfs = new Bfs();
			bfs.initBfs(width,height,maps);
			bfs.exeBfs(sta,end);
			//			trace("模拟蛇蛇头到蛇尾的距离",bfs.queue.length);
			if(bfs.queue.length>0){
				return true;
			}else{
				return false;
			}
		}
		
		private function generalMaps(snake:Snake):Vector.<Vector.<Boolean>>{
			var i:int=0;
			var maps:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>(width);
			for(i=0;i<width;i++){
				maps[i] = new Vector.<Boolean>(height);
			}
			
			var head:SnakeNode = SnakeNode(snake.snakeList.head);
			while(head)
			{
				maps[head.rec.x/sideLen][head.rec.y/sideLen] = true;
				head = SnakeNode(head.next);
			}
			maps[SnakeNode(snake.snakeList.back).rec.x/sideLen][SnakeNode(snake.snakeList.back).rec.y/sideLen] = false;
			
			return maps;
		}
	}
}
