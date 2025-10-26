# TODO: Make Flutter App Responsive

## Tasks
- [ ] Update Product_Card.dart: Replace fixed width (180) with responsive calculation using MediaQuery (e.g., MediaQuery.of(context).size.width * 0.4), adjust image height proportionally.
- [ ] Update category_card.dart: Make width and height responsive based on screen width (e.g., MediaQuery.of(context).size.width * 0.15 for ~15% screen width).
- [ ] Update Home/home_page.dart: Change GridView SliverGridDelegateWithFixedCrossAxisCount to SliverGridDelegateWithMaxCrossAxisExtent (maxCrossAxisExtent: 200) for dynamic columns; adjust header elements (profile image, text sizes) with MediaQuery.
- [ ] Update SignUp_page.dart: Scale font sizes (e.g., 'Sign Up' from 80 to proportional), paddings, and button sizes using MediaQuery.

## Followup Steps
- [ ] Run the app on different emulators/simulators (mobile, tablet) to test responsiveness.
- [ ] Adjust breakpoints if needed for larger screens.
