//
//  ViewController.swift
//  dot_game
//
//  Created by Farhan Rahman on 7/1/17.
//  Copyright © 2017 Farhan Rahman. All rights reserved.
//

import UIKit
import SocketIO


let socket = SocketIOClient(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .forcePolling(true)])



class ViewController: UIViewController {

    // Simple UI that allows you to have a socket.
    @IBOutlet weak var InitialBlock: UIImageView!



   // sees if the touches began.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        
        var location_x = location.x
        var location_y = location.y
        
        InitialBlock.frame = CGRect(x: location_x, y: location_y, width: InitialBlock.frame.size.width, height: InitialBlock.frame.size.height)

        
    }
    
    // Checks if a drag of touches is taking place you know what I mean boi.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        let touch = touches.first!
        let location = touch.location(in: self.view)
        
        
        var location_x = location.x
        var location_y = location.y
        
        
        //Update the frames with al
        InitialBlock.frame = CGRect(x: location_x, y: location_y, width: InitialBlock.frame.size.width, height: InitialBlock.frame.size.height)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.on(clientEvent: .connect) {data, ack in
            
            print("socket connected")
        
        }
        
        socket.on("welcome") {data, ack in
            print(data)
        }
        
        
        //Test EMIT motherfuckers.
        socket.emit("touchData", "hahahahahha")
 
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

