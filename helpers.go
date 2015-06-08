package main

import (
	"log"
	"os"
	"path/filepath"
)

func HomeDir() string {
	dir, err := filepath.Abs(filepath.Dir(os.Args[0]))
	if err != nil {
		log.Fatal(err)
	}
	return dir
}
