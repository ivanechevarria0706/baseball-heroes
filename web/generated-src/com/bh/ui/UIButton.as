package com.bh.ui {
    import flash.display.GradientType;
    import flash.display.Sprite;
    import com.bh.audio.AudioManager;
    import flash.events.MouseEvent;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;

    public class UIButton extends Sprite {
        private var customLabelSize:int=0;
        private var pillShape:Boolean=false;
        private var labelField:TextField;
        private var buttonW:Number;
        private var buttonH:Number;
        private var baseColor:uint;
        private var hoverColor:uint;
        private var borderColor:uint;
        private var labelText:String;

        public function UIButton(
            label:String,
            w:Number,
            h:Number,
            base:uint,
            hover:uint,
            border:uint = 0xffffff,
            labelSize:int = 0,
            pill:Boolean = false
        ) {
            super();

            customLabelSize=labelSize;pillShape=pill;
            buttonW = w;
            buttonH = h;
            baseColor = base;
            hoverColor = hover;
            borderColor = border;
            labelText = label;

            buttonMode = true;
            useHandCursor = true;
            mouseChildren = false;

            labelField = new TextField();
            labelField.selectable = false;
            labelField.mouseEnabled = false;
            labelField.multiline = true;
            labelField.wordWrap = true;
            addChild(labelField);

            redrawLabel(resolveTextColor(baseColor));
            draw(baseColor, false);

            addEventListener(MouseEvent.ROLL_OVER, onOver);
            addEventListener(MouseEvent.ROLL_OUT, onOut);
            addEventListener(MouseEvent.MOUSE_DOWN, onDown);
            addEventListener(MouseEvent.MOUSE_UP, onUp);
        }

        private function redrawLabel(textColor:uint):void {
            var fontSize:int;
            if (buttonH >= 56) fontSize = 20;
            else if (buttonH >= 42) fontSize = 14;
            else fontSize = 11;

            if(customLabelSize>0)fontSize=customLabelSize;
            var format:TextFormat = new TextFormat(
                "Arial",
                fontSize,
                textColor,
                true
            );
            format.align = TextFormatAlign.CENTER;
            labelField.defaultTextFormat = format;
            labelField.text = labelText;
            LineupTypography.apply(labelField,fontSize,textColor,TextFormatAlign.CENTER,true);
            labelField.width = buttonW - 8;
            labelField.height = buttonH - 4;
            labelField.x = 4;
            LineupTypography.fit(labelField,fontSize,textColor,TextFormatAlign.CENTER,true);
            labelField.y = Math.max(0,(buttonH-labelField.textHeight)/2-2);
            labelField.filters = [
                new GlowFilter(0x000000, 0.18, 2, 2, 1)
            ];
        }

        private function draw(color:uint, pressed:Boolean):void {
            graphics.clear();ClassicChrome.button(graphics,buttonW,buttonH,color,color==hoverColor,pressed,pillShape);
            redrawLabel(resolveTextColor(color));labelField.y+=pressed?1.5:0;cacheAsBitmap=true;
        }

        private function lighten(color:uint, amount:Number):uint {
            var r:int = color >> 16 & 0xff;
            var g:int = color >> 8 & 0xff;
            var b:int = color & 0xff;
            r += int((255 - r) * amount);
            g += int((255 - g) * amount);
            b += int((255 - b) * amount);
            return (r << 16) | (g << 8) | b;
        }

        private function darken(color:uint, amount:Number):uint {
            var r:int = color >> 16 & 0xff;
            var g:int = color >> 8 & 0xff;
            var b:int = color & 0xff;
            r -= int(r * amount);
            g -= int(g * amount);
            b -= int(b * amount);
            return (r << 16) | (g << 8) | b;
        }

        private function resolveTextColor(color:uint):uint {
            var r:Number = color >> 16 & 0xff;
            var g:Number = color >> 8 & 0xff;
            var b:Number = color & 0xff;
            var luma:Number = 0.299 * r + 0.587 * g + 0.114 * b;
            return luma > 170 ? 0x20313f : 0xffffff;
        }

        private function onOver(e:MouseEvent):void {
            draw(hoverColor, false);
            scaleX = scaleY = 1;
        }

        private function onOut(e:MouseEvent):void {
            draw(baseColor, false);
            scaleX = scaleY = 1;
        }

        private function onDown(e:MouseEvent):void {AudioManager.playUiClick();
            draw(hoverColor, true);
            scaleX = scaleY = 1;
        }

        private function onUp(e:MouseEvent):void {
            draw(hoverColor, false);
            scaleX = scaleY = 1;
        }

        public function setLabel(value:String):void {
            labelText = value;
            redrawLabel(resolveTextColor(baseColor));
        }

        public function dispose():void {
            removeEventListener(MouseEvent.ROLL_OVER, onOver);
            removeEventListener(MouseEvent.ROLL_OUT, onOut);
            removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            removeEventListener(MouseEvent.MOUSE_UP, onUp);
        }
    }
}
