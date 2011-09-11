﻿package ptolemy.geom3D.core{	import ptolemy.Maths;	import flash.display.Graphics;	import flash.events.Event;	public class Solid extends Logic	{		private var _faces:Array;		private var _colors:Array;		private var _outlineWidth:int = 0;		private var _outlineColor:uint = 0x000000FF;		private var _perspectiveDepth:Number;		private var _useAboutAngle:Boolean;		private var _about:SpatialVector;		private var _angle:Number;		private var _transformation:Transformation;		public function Solid(... faces)		{			if (faces.length == 1 && faces[0] is Array)				faces = faces[0];			_faces = faces;			_children = _faces.concat();			_useAboutAngle = true;			_about = new SpatialVector(0, 1, 0);			_about.addEventListener(SpatialVector.changed, onAboutChanged);			_angle = 0;		}		public function get faces():Array		{			return _faces;		}		internal function get perspectiveDepth():Number		{			return _perspectiveDepth;		}		public function get about():SpatialVector		{			return _about;		}		public function set about(v:SpatialVector):void		{			if (v == null || v == _about) return;			_useAboutAngle = true;			_about.removeEventListener(SpatialVector.changed, onAboutChanged);			_about = v;			_about.addEventListener(SpatialVector.changed, onAboutChanged);			invalidate();		}		private function onAboutChanged(e:Event):void		{			invalidate();		}		public function get angle():Number		{			return _angle;		}		public function set angle(n:Number):void		{			if (_angle == n) return;			_useAboutAngle = true;			_angle = n;			invalidate();		}		public function get directTransformation():Transformation		{			return _transformation;		}		public function set directTransformation(t:Transformation):void		{			if (_transformation == t) return;			_useAboutAngle = false;			_transformation = t;			invalidate();		}		public override function calculate(t:Transformation, e:Eye):void		{			if (_faces == null) return;			if (_useAboutAngle)				_transformation = Transformation.about(_about, _angle);			if (t != null)				t = Transformation.combine(_transformation, t);			else				t = _transformation;			super.calculate(t, e);		}		protected override function doCalculation(t:Transformation, e:Eye):void		{			var f:Face;			_perspectiveDepth = 0;			for each (f in _faces)			{				_perspectiveDepth += f.perspectiveDepth;			}			_perspectiveDepth /= _faces.length;			_children.sort(compareFunction);		}		public function get colors():Array		{			return _colors;		}		public function set colors(arr:Array):void		{			if (_colors == arr) return;			_colors = arr;			var i:int;			var f:Face;			i = 0;			for each (f in _faces)			{				f.fillColor = _colors[Maths.mod(i++, _colors.length)];			}			invalidate();		}		public function get outlineWidth():int		{			return _outlineWidth;		}		public function set outlineWidth(i:int):void		{			if (_outlineWidth == i) return;			_outlineWidth = i;			var f:Face;			for each (f in _faces )			{				f.outlineWidth = i;			}			invalidate();		}		public function get outlineColor():uint		{			return _outlineColor;		}		public function set outlineColor(i:uint):void		{			if (_outlineColor == i) return;			_outlineColor = i;			var f:Face;			for each (f in _faces)			{				f.outlineColor = i;			}			invalidate();		}		public function draw(g:Graphics):void		{			var f:Face;			for each (f in _children)			{				f.draw(g);			}		}		private function compareFunction(a:*, b:*):int		{			if (a.perspectiveDepth == null || b.perspectiveDepth == null) return 0;			if (a.perspectiveDepth < b.perspectiveDepth) return -1;			if (b.perspectiveDepth < a.perspectiveDepth) return 1;			return 0;		}	}}