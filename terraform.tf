resource local_file "local" {
    filename = "test.txt"
    content = "this is test file"
}

provider "local" {}