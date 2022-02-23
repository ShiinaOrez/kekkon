package main

type RequsterProfileInfo struct {
	Published  string       `json:"published"`
	FinderList []FinderInfo `json:"finder_list"`
}

type FinderInfo struct {
	FinderName string `json:"finder_name"`
	WeChat     string `json:"we_chat"`
}

type PublishInfo struct {
	Height   string `json:"height"`
	Weight   string `json:"weight"`
	Edu      string `json:"edu"`
	Hometown string `json:"hometown"`
	Msg      string `json:"msg"`
}
