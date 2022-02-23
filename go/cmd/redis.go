package main

import (
	"encoding/json"
	"fmt"
	"log"

	"github.com/go-redis/redis"
)

var (
	client = redis.NewClient(&redis.Options{
		Addr:     "116.62.7.230:6379",
		Password: "mashiro",
	})
)

func testClient() {
	pong, err := client.Ping().Result()
	log.Print(pong, err)
}

func init() {
	testClient()
}

func authKey(username string) string {
	return fmt.Sprintf("Kekkon-Auth-%s", username)
}

func infoKey(username string) string {
	return fmt.Sprintf("Kekkon-Info-%s", username)
}

func finderSetKey(username string) string {
	return fmt.Sprintf("Kekkon-Finder-%s", username)
}

func allInfoKey() string {
	return "Kekkon-All"
}

/*
 鉴权
 - kekkon-auth-{username}: password
 个人信息存储
 - kekkon-info-{username}: json.Marshal(PublishInfo)
 请求者集合
 - kekkon-finder-{username}: Set(json.Marshal(FinderInfo))
 全部用户信息集合
 - kekkon-all: Hash(username: json.Marshal(PublishInfo))
*/

func stAuth(username, password string) bool {
	return username == password
}

func stSetInfo(username string, info PublishInfo) {
	infoBytes, _ := json.Marshal(info)
	client.Set(infoKey(username), string(infoBytes), 0)
	return
}

func stGetInfo(username string) PublishInfo {
	info := &PublishInfo{}
	json.Unmarshal([]byte(client.Get(infoKey(username)).Val()), info)
	return *info
}

func stHasPublished(username string) bool {
	return client.Exists(infoKey(username)).Val() == 1
}

// func auth(username, password string) bool {
// 	passwordVal := client.Get(authKey(username)).Val()
// 	return password == passwordVal
// }

// func setPassword(username string, password string) {
// 	client.Set(authKey(username), password, 0)
// }

func stAddRequester(username string, finderName string, wechat string) {
	finderInfoBytes, _ := json.Marshal(FinderInfo{FinderName: finderName, WeChat: wechat})
	client.SAdd(finderSetKey(username), string(finderInfoBytes))
}

func stAddFinder(username, weChat, finder string) {
	bs, _ := json.Marshal(FinderInfo{
		FinderName: finder,
		WeChat:     weChat,
	})
	client.SAdd(finderSetKey(username), string(bs))
}

func stGetAllFinder(username string) []FinderInfo {
	strs, _ := client.SMembers(finderSetKey(username)).Result()
	results := []FinderInfo{}
	for _, str := range strs {
		result := &FinderInfo{}
		json.Unmarshal([]byte(str), result)
		results = append(results, *result)
	}
	return results
}

func stAddUserInfo(username string, info PublishInfo) {
	infoBytes, _ := json.Marshal(info)
	client.HSet(allInfoKey(), username, string(infoBytes))
}

func stGetAllUserInfo() map[string]PublishInfo {
	result, _ := client.HGetAll(allInfoKey()).Result()
	infoMap := map[string]PublishInfo{}
	for username, str := range result {
		info := &PublishInfo{}
		json.Unmarshal([]byte(str), info)
		infoMap[username] = *info
	}
	return infoMap
}
