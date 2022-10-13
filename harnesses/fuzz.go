package myfuzz

import "github.com/tidwall/gjson"

func Fuzz(data []byte) int {
	gjson.Get(string(data), "name.last")
	return 1
}
