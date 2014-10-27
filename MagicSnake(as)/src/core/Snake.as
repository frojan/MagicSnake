package core
{
	import flash.geom.Rectangle;
	import flash.net.dns.AAAARecord;
	
	import utils.Lists;

	public class Snake
	{
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		
		private var _speed:int = 1;
		
		private var _snakeList:Lists;
		private var _width:int;
		private var _height:int;
		private var _sideLen:int;
		
		public function Snake(width:int,height:int,sideLen:int)
		{
			_width = width;
			_height = height;
			_sideLen = sideLen;
			
			_snakeList = new Lists();
			for(var i:int=0;i<5;i++){
				var snakeNode:SnakeNode = new SnakeNode();
				snakeNode.rec = new Rectangle(sideLen * i ,0,sideLen,sideLen);
				snakeNode.dir = RIGHT;
				_snakeList.push_head(snakeNode);
			}
		}
		
		/**
		 * 移动函数
		 * @param dir 移动的方向 
		 * @param food 食物的位置
		 * @return 是否吃到食物
		 * 
		 */
		public function move(dir:String,food:Rectangle):Boolean{
			var head:SnakeNode = SnakeNode(_snakeList.head).clone();
			if((dir == UP && head.dir == DOWN) ||
			   (dir == DOWN && head.dir == UP) ||
			   (dir == LEFT && head.dir == RIGHT) ||
			   (dir == RIGHT && head.dir == LEFT))
			{
				dir = head.dir;
			}
			
			switch(dir)
			{
				case UP:
					head.rec.y -= _sideLen;
					break;
				case DOWN:
					head.rec.y += _sideLen;
					break;
				case LEFT:
					head.rec.x -= _sideLen;
					break;
				case RIGHT:
					head.rec.x += _sideLen;
					break;
			}
			head.dir = dir;
			_snakeList.push_head(head);
			
			//若吃到食物则返回则不需要删除蛇尾
			if(head.rec.x == food.x && head.rec.y == food.y){
				return true;
			}else{
				_snakeList.delete_back();
				return false;
			}
		}

		/**
		 * 判断贪吃蛇是否已死
		 * 1.撞到地图边界
		 * 2.撞到自己
		 * @return 
		 * 
		 */
		public function gamaOver():Boolean
		{
			var head:SnakeNode = SnakeNode(snakeList.head);
			if(head.rec.x < 0 || head.rec.x >= _width *_sideLen ||
			   head.rec.y < 0 || head.rec.y >= _height * _sideLen)
			{
				return true;
			}
			
			var headX:int = head.rec.x;
			var headY:int = head.rec.y;
			head = SnakeNode(head.next);
			while(head)
			{
				if(head.rec.x == headX && head.rec.y == headY){
					return true;
				}
				head = SnakeNode(head.next);
			}
			return false;
		}
		
		/**
		 * 克隆 
		 */
		public function clone():Snake{
			var snake:Snake = new Snake(_width,_height,_sideLen);
			var list:Lists = new Lists();
			var tem:SnakeNode = SnakeNode(_snakeList.head);
			var node:SnakeNode;
			while(tem)
			{
				node = new SnakeNode();
				node.dir = tem.dir;
				node.rec = tem.rec;
				list.push_back(node);
				tem = SnakeNode(tem.next);
			}
			snake.snakeList = list;
			return snake;
		}

		public function get snakeList():Lists
		{
			return _snakeList;
		}

		public function set snakeList(value:Lists):void
		{
			_snakeList = value;
		}
	}
}