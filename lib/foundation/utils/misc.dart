String combineID(String id1, id2) {
  return (id1.compareTo(id2) < 0) ? id1 + '-' + id2 : id2 + '-' + id1;
}
