package main

import (
	"fmt"
	"math/rand"
	"net/http"
	"os"
	"time"

	"github.com/sirupsen/logrus"
)

func main() {
	t := newTemperamental()
	http.Handle("/", t)
	if err := http.ListenAndServe(":8080", nil); err != nil {
		panic(err)
	}
}

type temperamental struct {
	rand *rand.Rand
}

func newTemperamental() *temperamental {
	source := rand.NewSource(time.Now().UnixNano())
	return &temperamental{
		rand: rand.New(source),
	}
}

func (t temperamental) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	status := t.rand.Intn(100)
	if status < 25 && !pacifierExists() {
		logrus.WithField("status", status).Errorf("I'm not happy")
		http.Error(w, "I'm not happy", http.StatusInternalServerError)
		return
	}

	fmt.Fprint(w, "I'm happy\n")
}

func pacifierExists() bool {
	info, err := os.Stat("/pacifier")
	if os.IsNotExist(err) {
		return false
	}

	return !info.IsDir()
}
