

# Production Simulation in R

This project simulates a production process using R6 classes in R. It involves multiple production units that manufacture and transport products through a defined network over several cycles.

## Features
- **Production Units**: Simulates units that manufacture, transport, and manage inventory.
- **Customizable**: Allows setting custom production and transportation values for each unit.
- **Simulation**: Runs for a specified number of cycles to track inventory flow between units.

## Installation
Make sure you have R installed. You can download it from [CRAN](https://cran.r-project.org/).

### Required Package
Install the `R6` package using the following command:

```r
install.packages("R6")
```

## Usage
1. **Define Units**: Create instances of the Unit class for each production unit.
2. **Set Relationships**: Define downstream and upstream connections between units.
3. **Run the Simulation**: Call the `simulate_production_process` function, specifying the number of cycles and the production/transportation values.

### Example

```r
library(R6)
# Define units, relationships, production, and transportation values
# Then, run the simulation
simulate_production_process(units, cycles, production_values, transportation_values)
```

## License
This project is licensed under the MIT License. A product of **Gathu**

---
This project was developed while sipping coffee and questioning whether I’m better at debugging code or making questionable life choices.
