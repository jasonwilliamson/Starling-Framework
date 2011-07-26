package 
{
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;
    
    import scenes.BenchmarkScene;
    import scenes.Scene;
    import scenes.TextureScene;
    import scenes.TouchScene;
    
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;

    public class Game extends Sprite
    {
        private var mMainMenu:Sprite;
        private var mCurrentScene:Scene;
        
        public function Game()
        {
            var bg:Image = new Image(Assets.getTexture("Background"));
            addChild(bg);
            
            mMainMenu = new Sprite();
            addChild(mMainMenu);
            
            var logo:Image = new Image(Assets.getTexture("Logo"));
            mMainMenu.addChild(logo);
            
            var scenesToCreate:Array = [
                ["Textures",   TextureScene],
                ["Multitouch", TouchScene],
                ["Benchmark",  BenchmarkScene]
            ];
            
            var buttonTexture:Texture = Assets.getTexture("ButtonBig");
            var count:int = 0;
            
            for each (var sceneToCreate:Array in scenesToCreate)
            {
                var sceneTitle:String = sceneToCreate[0];
                var sceneClass:Class  = sceneToCreate[1];
                
                var button:Button = new Button(buttonTexture, sceneTitle);
                button.x = count % 2 == 0 ? 28 : 167;
                button.y = 150 + (count / 2) * 52 /* + (count % 2) * 26 */;
                button.name = getQualifiedClassName(sceneClass);
                button.addEventListener(Event.TRIGGERED, onButtonTriggered);
                mMainMenu.addChild(button);
                ++count;
            }
            
            addEventListener(Scene.CLOSING, onSceneClosing);
        }
        
        private function onButtonTriggered(event:Event):void
        {
            var button:Button = event.target as Button;
            showScene(button.name);
        }
        
        private function onSceneClosing(event:Event):void
        {
            mCurrentScene.removeFromParent(true);
            mCurrentScene = null;
            mMainMenu.visible = true;
        }
        
        private function showScene(name:String):void
        {
            if (mCurrentScene) return;
            
            var sceneClass:Class = getDefinitionByName(name) as Class;
            mCurrentScene = new sceneClass() as Scene;
            mMainMenu.visible = false;
            addChild(mCurrentScene);
        }
    }
}