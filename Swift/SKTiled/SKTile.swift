//
//  SKTile.swift
//  SKTiled
//
//  Created by Michael Fessenden on 3/21/16.
//  Copyright © 2016 Michael Fessenden. All rights reserved.
//

import SpriteKit


/// represents a single tile object.
public class SKTile: SKSpriteNode {
    
    public var tileData: SKTilesetData          // tile data
    weak public var layer: SKTileLayer!         // layer parent, assigned on add
    
    /// Highlight the tile. Currently used in debugging.
    public var highlight: Bool = false {
        didSet {
            guard oldValue != highlight else { return }
            removeActionForKey("DEBUG_FADE")
            color = (highlight == true) ? SKColor.blackColor() : SKColor.clearColor()
            colorBlendFactor = (highlight == true) ? 0.7 : 0
            if (highlight == true) {
                let fadeAction = SKAction.colorizeWithColor(SKColor.clearColor(), colorBlendFactor: 0, duration: 2.5)
                runAction(fadeAction, withKey: "DEBUG_FADE", optionalCompletion: { self.highlight = false })
            }
        }
    }
    
    /**
     Initialize the tile object with `SKTilesetData`.
     
     - parameter data: `SKTilesetData` tile data.
     
     - returns: `SKTile`.
     */
    public init(data: SKTilesetData){
        self.tileData = data
        super.init(texture: data.texture, color: SKColor.clearColor(), size: data.texture.size())
    }
        
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Animation
    
    /**
     Check if the tile is animated and run an action to animated it.
     */
    public func runAnimation(){
        guard tileData.isAnimated == true else { return }
        
        var tileTextures: [SKTexture] = []
        for frameID in tileData.frames {
            guard let frameTexture = tileData.tileset.getTileData(frameID)?.texture else {
                print("Error: Cannot access texture for id: \(frameID)")
                return
            }
            tileTextures.append(frameTexture)
                }
        
        var animAction = SKAction.animateWithTextures(tileTextures, timePerFrame: tileData.duration)
        var repeatAction = SKAction.repeatActionForever(animAction)
        runAction(repeatAction, withKey: "TILE_ANIMATION")
            }
    
    /// Pauses tile animation
    public var pauseAnimation: Bool = false {
        didSet {
            guard oldValue != pauseAnimation else { return }
            guard let action = actionForKey("TILE_ANIMATION") else { return }
            action.speed = (pauseAnimation == true) ? 0 : 1.0
        }
    }
}


extension SKTile {
    
    override public var description: String {
        var descString = "\(tileData.description)"
        let descGroup = descString.componentsSeparatedByString(",")
        var resultString = descGroup.first!
        if let layer = layer {
            resultString += ", Layer: \"\(layer.name!)\""
        }

        // add the properties
        if descGroup.count > 1 {
            for i in 1..<descGroup.count {
                resultString += ", \(descGroup[i])"
            }
        }
        
        return resultString
    }
    
    override public var debugDescription: String {
        return description
    }
}
