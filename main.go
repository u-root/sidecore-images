// Copyright 2023 the u-root Authors. All rights reserved
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// list all files in / and create a cpio from them.
package main

import (
	"fmt"
	"io/fs"
	"log"
	"os"
	"path/filepath"

	"github.com/u-root/u-root/pkg/cpio"
)

func main() {
	archiver, err := cpio.Format("newc")
	if err != nil {
		log.Fatal(err)
	}

	rw := archiver.Writer(os.Stdout)
	cr := cpio.NewRecorder()

	if err := filepath.WalkDir("/", func(n string, d fs.DirEntry, err error) error {
		// Even for directories we skip, add a record.
		rec, err := cr.GetRecord(n)
		if err != nil {
			return fmt.Errorf("Getting record of %q (%v) failed: %w", n, d, err)
		}
		if err := rw.WriteRecord(rec); err != nil {
			return fmt.Errorf("Writing record %q (%v) failed: %w", n, d, err)
		}
		log.Printf("%q", n)
		switch n {
		case "/home", "/sys", "/dev", "/proc":
			return fs.SkipDir
		}
		return nil
	}); err != nil {
		log.Fatal(err)
	}

	if err := cpio.WriteTrailer(rw); err != nil {
		log.Fatalf("Error writing trailer record: %w", err)
	}

}
