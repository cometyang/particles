#' Center all particles around the origin without affecting velocity
#'
#' This force repositions the particles at each generation so they are centered
#' around (0,0). It does not affect the velocity of the particles and are thus
#' mainly a guard against the whole body of particles drifting off.
#'
#' @section Training parameters:
#' There are no parameters for this force.
#'
#' @family forces
#' @usage NULL
#' @format NULL
#' @export
center_force <- structure(list(
), class = c('center_force', 'force'))
#' @export
print.center_force <- function(x, ...) {
  cat('Center Force:\n')
  cat('* A force that keeps all particles centered around the origin\n')
}
train_force.center_force <- function(force, particles, ...) {
  force <- NextMethod()
  force
}
#' @importFrom rlang quos
#' @importFrom digest digest
retrain_force.center_force <- function(force, particles, ...) {
  dots <- quos(...)
  particle_hash <- digest(particles)
  new_particles <- particle_hash != force$particle_hash
  force$particle_hash <- particle_hash
  nodes <- as_tibble(particles, active = 'nodes')
  force <- update_quo(force, 'include', dots, nodes, new_particles, TRUE)
  force
}
apply_force.center_force <- function(force, particles, pos, vel, alpha, ...) {
  center <- matrix(colMeans(pos), nrow = nrow(pos), ncol = ncol(pos), byrow = TRUE)
  pos <- pos - center
  list(position = pos, velocity = vel)
}
