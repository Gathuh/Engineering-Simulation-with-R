# Create a Unit structure to track stock and its sources

Unit <- function(name) {
  list(
    name = name,
    stock = 0,
    stock_sources = list(),
    update_stock = function(produced_amount, source_unit = NULL) {
      stock <<- stock + produced_amount
      if (!is.null(source_unit)) {
        if (!is.null(stock_sources[[source_unit]])) {
          stock_sources[[source_unit]] <<- stock_sources[[source_unit]] + produced_amount
        } else {
          stock_sources[[source_unit]] <<- produced_amount
        }
      }
    },
    get_stock_proportions = function() {
      total_stock <- sum(unlist(stock_sources))
      proportions <- sapply(stock_sources, function(amount) amount / total_stock)
      return(proportions)
    }
  )
}

# Define the production and shipment functions
production_function_X <- function(t, a, p) {
  return(a * t^p)
}

shipment_function_Y <- function(t, d, q) {
  return(d * t^q)
}

# Simulate one round of production and shipment
simulate_production_round <- function(units, t, production_params) {
  # First, calculate production for each unit
  for (unit in units) {
    a <- production_params[[unit$name]]$a
    p <- production_params[[unit$name]]$p
    produced_amount <- production_function_X(t, a, p)
    
    # Update the unit's stock with the produced amount
    unit$update_stock(produced_amount)
  }
  
  # Then, simulate the shipments to upstream units
  for (unit in units) {
    if (!is.null(unit$upstream)) {
      # Shipment depends on parameters d, q for Y
      d <- production_params[[unit$name]]$d
      q <- production_params[[unit$name]]$q
      shipped_amount <- shipment_function_Y(t, d, q)
      
      # Distribute the shipment to all upstream units
      for (upstream_unit in unit$upstream) {
        upstream_unit$update_stock(shipped_amount, source_unit = unit$name)
      }
    }
  }
}

# Simulate multiple rounds
simulate_n_rounds <- function(n, t_values, units, production_params) {
  for (i in seq_len(n)) {
    t <- t_values[i]
    cat("Simulating round", i, "with t =", t, "\n")
    simulate_production_round(units, t, production_params)
  }
  
  # After all rounds, return the stock proportions for each unit
  stock_proportions <- list()
  for (unit in units) {
    stock_proportions[[unit$name]] <- unit$get_stock_proportions()
  }
  
  return(stock_proportions)
}

# Example usage

# Create units
C1 <- Unit("C1")
C2 <- Unit("C2")
C3 <- Unit("C3")
C3$upstream <- list(C1, C2)  # C3 receives from C1 and C2

# List of units
units <- list(C1, C2, C3)

# Define production parameters for each unit
production_params <- list(
  C1 = list(a = 2.0, p = 1.5, d = 1.2, q = 0.8),
  C2 = list(a = 1.8, p = 1.2, d = 1.1, q = 0.9),
  C3 = list(a = 1.5, p = 1.0, d = 1.3, q = 0.7)
)

# Define t values for each round
t_values <- c(0.0, 0.2, 0.3, 0.5)

# Simulate production for 4 rounds
n_rounds <- length(t_values)
stock_proportions <- simulate_n_rounds(n_rounds, t_values, units, production_params)

# Print stock proportions for each unit after all rounds
for (unit_name in names(stock_proportions)) {
  cat("Final stock proportions for", unit_name, ":\n")
  print(stock_proportions[[unit_name]])
}
