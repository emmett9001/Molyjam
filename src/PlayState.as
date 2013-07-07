package{
    import org.flixel.*;
    import org.flixel.system.FlxTile;

    public class PlayState extends FlxState {
        [Embed(source="../assets/mapCSV_Group1_Map1.csv", mimeType = "application/octet-stream")] private var Map:Class;
        [Embed(source="../assets/tiles1.png")] private var ImgTiles:Class;
        protected var _level:FlxTilemap;
        protected var _player:Player;
        protected var _momGrp:FlxGroup;
        protected var _text:FlxText;
        protected var _snackGrp:FlxGroup;
        protected var _timer:Number;

        override public function create():void{
            _timer = 0;

            _level = new FlxTilemap();
            _level.loadMap(new Map,ImgTiles,8,8,FlxTilemap.OFF);
            _level.follow();
            add(_level);

            _level.setTileProperties(1,0,null,null,10);
            _level.setTileProperties(15,0);
            _level.setTileProperties(44,0,null,null,4);

            _player = new Player(170,100);
            add(_player);

            FlxG.worldBounds = new FlxRect(0, 0, _level.width, _level.height);

            var cam:ZoomCamera = new ZoomCamera(0, 0, 640, 480);
            FlxG.resetCameras(cam);
            cam.follow(_level);
            cam.target = _player;
            cam.targetZoom = 3;

            _momGrp = new FlxGroup();
            for(var i:Number = 0; i < 2; i++){
                var _mom:Mom = new Mom(Math.random()*(300-100)+100,Math.random()*(300-100)+100,_level);
                _momGrp.add(_mom);
                add(_mom);
            }

            _snackGrp = new FlxGroup();

            for(i = 0; i < 20; i++){
                var _snack:Snacks = new Snacks(Math.random()*(300),Math.random()*(300));
                add(_snack);
                _snackGrp.add(_snack);
            }
        }

        override public function update():void{
            super.update();

            _timer += FlxG.elapsed;

            FlxG.collide(_player, _level);

            for(var i:Number = 0; i < _momGrp.length; i++){
                _momGrp.members[i].searchFor(_player, _timer);
                if(_player.snackGrabbed &&
                 _momGrp.members[i].isInRange(new FlxPoint(_player.x, _player.y))){
                    // Game over
                }
            }

            _player.isGrabbing();

            if(FlxG.keys.Z){
                if(_player.snackGrabbed == null){
                    for(i = 0; i < _snackGrp.length; i++){
                        if(_player.overlaps(_snackGrp.members[i])){
                            _player.isGrabbing(_snackGrp.members[i]);
                        }
                    }
                }
            } else {
                _player.snackGrabbed = null;
            }
        }
    }
}
