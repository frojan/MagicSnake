package Bfs
{
	import utils.Lists;

	public class Bfs
	{
		
		private var _width:int;
		private var _height:int;
		/**蛇身*/
		private var _maps:Vector.<Vector.<Boolean>>;
		private var _visited:Vector.<Vector.<Boolean>>;
		private var _parents:Vector.<Vector.<PointNode>>;
		private var _queue:Lists;
		
		private var dir:Array=[[0,1],[0,-1],[1,0],[-1,0]];
		
		public function Bfs()
		{
		}
		
		public function initBfs(width:int,height:int,maps:Vector.<Vector.<Boolean>>):void{
			_width = width;
			_height = height;
			_maps = maps;
			
		}
		private function init():void{
			_visited = new  Vector.<Vector.<Boolean>>();
			_parents = new Vector.<Vector.<PointNode>>();
			_queue = new Lists();
			
			var i:int,j:int;
			for(i=0;i<_width;i++){
				_visited[i] = new Vector.<Boolean>();
				_parents[i] = new Vector.<PointNode>();
				for(j=0;j<_height;j++){
					_visited[i][j] = false;
					_parents[i][j] = new PointNode();
					_parents[i][j].x = -1;
					_parents[i][j].y = -1;
				}
			}
		}
		private function calcBfs(startPos:PointNode,endPos:PointNode):void{
			var tempQue:Lists = new Lists();
			tempQue.push_back(startPos);
			_visited[startPos.x][startPos.y] = true;
			
			var length:int;
			var head:PointNode,next:PointNode;
			while(!tempQue.empty()){
				length = tempQue.length;
				while(length--){
					head = PointNode(tempQue.head);
					tempQue.delete_head();
					if(head.x == endPos.x && head.y == endPos.y){
						return;
					}
					for(var i:int=0;i<4;i++){
						next = new PointNode();
						next.x = head.x +dir[i][0];
						next.y = head.y +dir[i][1];
						if(next.x<0||(next.x>(_width-1))||  
							next.y<0||(next.y>(_height-1))||  
							_maps[next.x][next.y])  
							continue; 
						
						if(!_visited[next.x][next.y])  
						{  
							_visited[next.x][next.y]=true;  
							tempQue.push_back(next);  
							_parents[next.x][next.y].x=head.x;  
							_parents[next.x][next.y].y=head.y;  
						}  
					}
				}
			}
		}
		
		private function clacQue(endPos:PointNode):void{
			if(endPos.x != -1 && endPos.y != -1){
				clacQue(_parents[endPos.x][endPos.y]);
				_queue.push_back(endPos);
			}
		}
		
		/**
		 * 执行算法 
		 */
		public function exeBfs(startPos:PointNode,endPos:PointNode):Lists{
			init();
			if(startPos.x >= 0 && startPos.x < _width && 
			   startPos.y >= 0 && startPos.y < _height &&
			   endPos.x >= 0 && endPos.x < _width && 
			   endPos.y >= 0 && endPos.y < _height
			){
				calcBfs(startPos,endPos);
				clacQue(endPos);
				_queue.delete_head();
			}
			
			return _queue;
		}

		public function get queue():Lists
		{
			return _queue;
		}

	}
}