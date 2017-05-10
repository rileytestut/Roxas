//: Playground - noun: a place where people can play

import Roxas
import PlaygroundSupport

let placeholderView = RSTPlaceholderView(frame: CGRect(x: 0, y: 0, width: 320, height: 568))
placeholderView.textLabel.text = "Roxas Playground"
placeholderView.detailTextLabel.text = "Use this Playground to try out Roxas features, and have fun!"
placeholderView.backgroundColor = UIColor.white

PlaygroundPage.current.liveView = placeholderView