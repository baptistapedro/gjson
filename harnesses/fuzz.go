package myfuzz

import "github.com/tidwall/gjson"

func Fuzz(data []byte) int {
	value := gjson.Get(string(data), "name.last")
	println(value.String())
	return 1
}
