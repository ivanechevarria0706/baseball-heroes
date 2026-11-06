# Phase 7C — Audio + Compile Hotfix

Fixed compiler error:

`Access of undefined property labelText`

Cause:
`UIButton.as` stores its label in `labelField`, but the newly-added
`setLabel()` method referenced the nonexistent `labelText`.

Fixed:
```actionscript
public function setLabel(value:String):void {
    labelField.text = value;
}
```

Also hardened `AudioManager` volume handling by explicitly applying a
`SoundTransform`.

Integrated the three MP3 files supplied by the user:
- Baseball heroes.mp3 -> `assets/audio/baseball_heroes.mp3`
- Locker room.mp3 -> `assets/audio/locker_room.mp3`
- Shop.mp3 -> `assets/audio/shop.mp3`
