String formatDate(String inputDate) {
  if (inputDate.length == 8) {
    String year = inputDate.substring(0, 4);
    String month = inputDate.substring(4, 6);
    String day = inputDate.substring(6, 8);
    return '$day/$month/$year';
  }
  return inputDate;
}