package core
{
	import flash.geom.Rectangle;
	import utils.ListNode;

	public class SnakeNode extends ListNode
	{ 
		/**节点矩形*/
		public var rec:Rectangle;
		/**节点方向*/
		public var dir:String;
		
		public function SnakeNode()
		{
		}
		
		public function clone():SnakeNode{
			var snakeNode:SnakeNode = new SnakeNode();
			snakeNode.rec = rec.clone();
			snakeNode.dir = dir;
			return snakeNode;
		}
	}
}