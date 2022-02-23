package main

func opLogin(username, password string) bool {
	return false
}

func opHasPublished(username string) bool {
	return stHasPublished(username)
}

func opPublishInfo(username, height, weight, edu, hometown, msg string) {
	info := PublishInfo{
		Height:   height,
		Weight:   weight,
		Edu:      edu,
		Hometown: hometown,
		Msg:      msg,
	}
	stSetInfo(username, info)
	stAddUserInfo(username, info)
}

func opGetAllFinder(username string) []FinderInfo {
	return stGetAllFinder(username)
}

func opGetAllRequester() map[string]PublishInfo {
	return stGetAllUserInfo()
}

func opFind(username, weChat, finder string) {
	stAddFinder(username, weChat, finder)
}
