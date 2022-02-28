package main

import (
	"encoding/json"
	"fmt"

	"github.com/go-flutter-desktop/go-flutter"
	"github.com/go-flutter-desktop/go-flutter/plugin"
	"github.com/go-gl/glfw/v3.3/glfw"
)

var options = []flutter.Option{
	flutter.WindowInitialDimensions(1100, 620),
	flutter.AddPlugin(&AppRequester{}),
}

type AppRequester struct {
	window   *glfw.Window
	userName string
	password string
}

type ReqError struct {
	Type     string `json:"type"`
	ErrorMsg string `json:"error_msg"`
}

var _ flutter.Plugin = &AppRequester{}
var _ flutter.PluginGLFW = &AppRequester{}

func (a *AppRequester) InitPlugin(messenger plugin.BinaryMessenger) error {
	channel := plugin.NewMethodChannel(messenger, "kekkon/requester", plugin.StandardMethodCodec{})
	channel.HandleFunc("login", a.login)
	channel.HandleFunc("get_all_users", a.getAllUsers)
	channel.HandleFunc("publish", a.publish)
	channel.HandleFunc("has_published", a.hasPublished)
	channel.HandleFunc("get_finders", a.getFinders)
	channel.HandleFunc("find", a.find)
	return nil
}

func (a *AppRequester) InitPluginGLFW(window *glfw.Window) error {
	a.window = window
	return nil
}

func (a AppRequester) login(arguments interface{}) (reply interface{}, err error) {
	fmt.Println(arguments)
	argumentsMap, ok := arguments.(map[interface{}]interface{})
	if !ok {
		return buildReqErrorStr("Err01 - Invoke method arguments mistake", "Type assert failed. "), nil
	}
	username := argumentsMap["username"].(string)
	password := argumentsMap["password"].(string)
	if username == "" {
		return buildReqErrorStr("Err02 - Login failed", "Username is empty. "), nil
	}
	if password == "" {
		return buildReqErrorStr("Err02 - Login failed", "Password is empty. "), nil
	}
	if username != password {
		return buildReqErrorStr("Err02 - Login failed", "Wrong password. "), nil
	}
	return "", nil
}

func (a AppRequester) hasPublished(arguments interface{}) (reply interface{}, err error) {
	fmt.Println("method: hasPublished. args:", arguments)
	argumentsMap, ok := arguments.(map[interface{}]interface{})
	if !ok {
		return buildReqErrorStr("Err01 - Invoke method arguments mistake", "Type assert failed. "), nil
	}
	username := argumentsMap["username"].(string)
	if username == "" {
		return buildReqErrorStr("Err02 - Get info failed", "Username is empty. "), nil
	}
	return opHasPublished(username), nil
}

func (a AppRequester) getFinders(arguments interface{}) (reply interface{}, err error) {
	fmt.Println(arguments)
	argumentsMap, ok := arguments.(map[interface{}]interface{})
	if !ok {
		return buildReqErrorStr("Err01 - Invoke method arguments mistake", "Type assert failed. "), nil
	}
	username := argumentsMap["username"].(string)
	if username == "" {
		return buildReqErrorStr("Err02 - Get info failed", "Username is empty. "), nil
	}

	finderList := opGetAllFinder(username)
	bs, _ := json.Marshal(finderList)
	return string(bs), nil
}

func (a AppRequester) publish(arguments interface{}) (reply interface{}, err error) {
	fmt.Println(arguments)
	argumentsMap, ok := arguments.(map[interface{}]interface{})
	if !ok {
		return buildReqErrorStr("Err01 - Invoke method arguments mistake", "Type assert failed. "), nil
	}
	username := argumentsMap["username"].(string)
	height := argumentsMap["height"].(string)
	weight := argumentsMap["weight"].(string)
	edu := argumentsMap["edu"].(string)
	hometown := argumentsMap["hometown"].(string)
	msg := argumentsMap["msg"].(string)

	if username == "" {
		return buildReqErrorStr("Err02 - Publish info failed", "Username is empty. "), nil
	}
	opPublishInfo(username, height, weight, edu, hometown, msg)
	return "", nil
}

func (a AppRequester) getAllUsers(arguments interface{}) (reply interface{}, err error) {
	bs, _ := json.Marshal(opGetAllRequester())
	fmt.Println("AllUsers:", string(bs))
	return string(bs), nil
}

func (a AppRequester) find(arguments interface{}) (reply interface{}, err error) {
	argumentsMap, ok := arguments.(map[interface{}]interface{})
	if !ok {
		return buildReqErrorStr("Err01 - Invoke method arguments mistake", "Type assert failed. "), nil
	}
	username := argumentsMap["username"].(string)
	if username == "" {
		return buildReqErrorStr("Err02 - Get info failed", "Username is empty. "), nil
	}
	weChat := argumentsMap["wechat"].(string)
	finder := argumentsMap["finder"].(string)
	opFind(username, weChat, finder)

	return "", nil
}

func buildReqErrorStr(t, msg string) string {
	errMsg := ReqError{
		Type:     t,
		ErrorMsg: msg,
	}
	bs, _ := json.Marshal(errMsg)
	return string(bs)
}
