package utils 
{
	public class Lists
	{
		private var _head:ListNode;
		private var _back:ListNode;
		
		private var _length:int;
		
		public function Lists()
		{
			_length = 0;
		}
		/**
		 * 列表尾部插入节点
		 * 
		 */	
		public function push_back(node:ListNode):void
		{
			if(_length==0){
				node.next = null;
				node.pro = null;
				_head = _back = node;
			}else{
				_back.next = node;
				node.pro = _back;
				node.next = null;
				_back = node;
			}
			_length++;
		}
		/**
		 * 列表头部插入节点
		 * 
		 */		
		public function push_head(node:ListNode):void
		{
			if(_length==0){
				node.next = null;
				node.pro = null;
				_head = _back = node;
			}else{
				_head.pro = node;
				node.pro = null;
				node.next = _head;
				_head = node;
			}
			_length++;
		}
		/**
		 * 删除头节点 
		 * 
		 */		
		public function delete_head():void{
			if(length>0){
				if(length == 1){
					_head = _back = null;
				}else{
					_head = _head.next;
					_head.pro = null;
				}
				_length--;
			}
		}
		/**
		 * 删除尾节点 
		 * 
		 */		
		public function delete_back():void{
			if(length>0){
				if(length == 1){
					_head = _back = null;
				}else{
					_back = _back.pro;
					_back.next = null;
				}
				_length--;
			}
		}
		
		public function empty():Boolean{
			return length==0?true:false;
		}
		
		public function get head():ListNode
		{
			return _head;
		}
		
		public function get back():ListNode
		{
			return _back;
		}

		public function get length():int
		{
			return _length;
		}
	}
}