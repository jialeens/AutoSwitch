//
//  AppDelegate.swift
//  AutoSwitch
//
//  Created by ens on 2019/4/15.
//  Copyright © 2019 jialeens. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    @IBAction func openPreference(_ sender: Any) {
        
    }
    @IBAction func appClose(_ sender: Any) {
        NSApplication.shared.terminate(self);
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "🌞";
        statusItem.menu = statusMenu;
        self.addNotifications();
    }
    
    /// <#Description#> 增加监听器
    func addNotifications() {
        NSLog("fileNotifications", NSNull())
        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onWakeNote(note:)),
            name: NSWorkspace.didWakeNotification, object: nil)

        NSWorkspace.shared.notificationCenter.addObserver(
            self, selector: #selector(onSleepNote(note:)),
            name: NSWorkspace.willSleepNotification, object: nil)
    }
    
    /// <#Description#> 唤醒时方法
    ///
    /// - Parameter note: <#note description#>
    @objc func onWakeNote(note: NSNotification) {
        commandLineTask("/bin/sh",["-c","networksetup -setairportpower 'Wi-Fi' on"])
        commandLineTask("/usr/local/bin/blueutil",["--power","1"])
    }
    
    /// <#Description#> 休眠时方法
    ///
    /// - Parameter note: <#note description#>
    @objc func onSleepNote(note: NSNotification) {
        commandLineTask("/bin/sh",["-c","networksetup -setairportpower 'Wi-Fi' off"])
        commandLineTask("/usr/local/bin/blueutil",["--power","0"])
    }
    func applicationWillTerminate(_ aNotification: Notification) {
        NSLog("app exit!", NSNull())
    }
    
    /// <#Description#> 执行通用命令方法
    ///
    /// - Parameters:
    ///   - launchpath: <#launchpath description#>
    ///   - command: <#command description#>
    func commandLineTask(_ launchpath : String,_ command: [String]) {
        let process = Process()
        process.launchPath = launchpath
        let arguments = command
        print(arguments)
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        let file = pipe.fileHandleForReading
        process.launch()
        let data = file.readDataToEndOfFile()
        let string = String(data: data, encoding: .utf8)
        
        print("got \n" + (string ?? ""))
    }
}

